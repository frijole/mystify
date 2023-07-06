import AppKit

struct Corner: Equatable {
  let position: CGPoint
  let velocity: CGVector

  func advance(within bounds: CGRect) -> Corner {
    var newPosition = CGPoint(x: position.x + velocity.dx, y: position.y + velocity.dy)
    var newVelocity = velocity

    if newPosition.x < 0 {
      newPosition.x = 0
      newVelocity.dx = -1 * velocity.dx
    } else if newPosition.x > bounds.width {
      newPosition.x = bounds.width
      newVelocity.dx = -1 * velocity.dx
    }

    if newPosition.y < 0 {
      let underrun = newPosition.y
      newPosition.y = 0
      newVelocity.dy = -1 * velocity.dy
    } else if newPosition.y > bounds.height {
      let overrun = bounds.height - newPosition.y
      newPosition.y = bounds.height
      newVelocity.dy = -1 * velocity.dy
    }

    // todo: adjust velocity
    // later: change color when hitting wall?

    return Corner(position: newPosition, velocity: newVelocity)
  }
}

struct Wire: Equatable {
  let corners: [Corner]
  let color: NSColor

  func advance(within bounds: CGRect) -> Wire {
    Wire(
      corners: corners.map({ $0.advance(within: bounds) }),
      color: color
    )
  }

  var wirePath: NSBezierPath {
    let path = NSBezierPath()
    guard let firstCorner = corners.first else { return path }
    path.move(to: firstCorner.position)
    corners.dropFirst().forEach { corner in
      path.line(to: corner.position)
    }
    path.close()
    path.lineWidth = 1
    return path
  }
}

struct WireSnapshot: Equatable {
  let wires: [Wire]

  func advance(within bounds: CGRect) -> WireSnapshot {
    return WireSnapshot(wires: wires.map({ $0.advance(within: bounds) }))
  }
}

struct WireConfiguration: Equatable {
  let bounds: CGRect
  let wireCount: Int
  let wireHistory: Int
  let colors: [NSColor]
}

extension Wire {
  static func randomWire(in bounds: CGRect, color: NSColor = .cyan) -> Wire {
    return Wire(
      corners: [
        .randomCorner(in: bounds),
        .randomCorner(in: bounds),
        .randomCorner(in: bounds),
        .randomCorner(in: bounds)
      ],
      color: color
    )
  }
}

extension Corner {
  static func randomCorner(in bounds: CGRect) -> Corner {
    let randomPosition = CGPoint(
      x: Double(Int.random(in: 0...Int(bounds.width))),
      y: Double(Int.random(in: 0...Int(bounds.height)))
    )
    let randomVelocity = CGVector(
      dx: Double(Int.random(in: -10...10)),
      dy: Double(Int.random(in: -20...20))
    )
    return Corner(position: randomPosition, velocity: randomVelocity)
  }
}

struct State {
  let bounds: CGRect
  let snapshots: [WireSnapshot]

  init(configuration: WireConfiguration) {
    bounds = configuration.bounds
    var wires = [Wire]()
    for index in 1...configuration.wireCount {
      let color = configuration.colors[index % configuration.colors.count]
      wires.append(.randomWire(in: bounds, color: color))
    }
    snapshots = [WireSnapshot(wires: wires)]
  }

  init(bounds: CGRect, snapshots: [WireSnapshot]) {
    self.bounds = bounds
    self.snapshots = snapshots
  }

  public func advance() -> State {
    var newSnapshots = snapshots
    guard let newSnapshot = newSnapshots.last?.advance(within: bounds) else { return self }
    newSnapshots.append(newSnapshot)
    while newSnapshots.count > 5 {
      newSnapshots.remove(at: 0)
    }
    return State(bounds: bounds, snapshots: newSnapshots)
  }
}
