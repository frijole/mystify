import AppKit

struct Corner {
  let position: CGPoint
  let velocity: CGVector

  func advance(within bounds: CGRect) -> Corner {
    var newPosition = CGPoint(x: position.x + velocity.dx, y: position.y + velocity.dy)
    var newVelocity = velocity

    if newPosition.x < 0 {
      let underrun = newPosition.x
      newPosition.x = -1 * underrun
      newVelocity.dx = -1 * velocity.dx
    } else if newPosition.x > bounds.width {
      let overrun = bounds.width - newPosition.x
      newPosition.x = newPosition.x - overrun
      newVelocity.dx = -1 * velocity.dx
    }

    if newPosition.y < 0 {
      let underrun = newPosition.y
      newPosition.y = -1 * underrun
      newVelocity.dy = -1 * velocity.dy
    } else if newPosition.y > bounds.height {
      let overrun = bounds.height - newPosition.y
      newPosition.y = newPosition.y - overrun
      newVelocity.dy = -1 * velocity.dy
    }

    // todo: adjust velocity
    // later: change color when hitting wall?

    return Corner(position: newPosition, velocity: newVelocity)
  }
}

struct Wire {
  let corners: [Corner]
  let color: NSColor

  func advance(within bounds: CGRect) -> Wire {
    Wire(
      corners: corners.map({ $0.advance(within: bounds) }),
      color: color
    )
  }
}

struct WireSnapshot {
  let wires: [Wire]

  func advance(within bounds: CGRect) -> WireSnapshot {
    return WireSnapshot(wires: wires.map({ $0.advance(within: bounds) }))
  }
}

struct WireConfiguration {
  let bounds: CGRect
  let wireCount: Int
  let wireHistory: Int
  let colors: [NSColor]
}

extension Wire {
  static func randomWire(in bounds: CGRect) -> Wire {
    return Wire(
      corners: [
        .randomCorner(in: bounds),
        .randomCorner(in: bounds),
        .randomCorner(in: bounds),
        .randomCorner(in: bounds)
      ],
      color: .cyan
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
    for _ in 0...configuration.wireCount {
      wires.append(.randomWire(in: bounds))
    }
    snapshots = [WireSnapshot(wires: wires)]
  }

  init(bounds: CGRect, snapshots: [WireSnapshot]) {
    self.bounds = bounds
    self.snapshots = snapshots
  }

  func advance() -> State {
    var newSnapshots = snapshots
    guard let newSnapshot = newSnapshots.last?.advance(within: bounds) else { return self }
    newSnapshots.append(newSnapshot)
    while newSnapshots.count > 5 {
      newSnapshots.remove(at: 0)
    }
    return State(bounds: bounds, snapshots: newSnapshots)
  }
}
