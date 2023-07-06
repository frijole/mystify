import ScreenSaver

class MystifyView: ScreenSaverView {

  let wireConfiguration: WireConfiguration
  var wireState: State

  override init?(frame: NSRect, isPreview: Bool) {
    wireConfiguration = WireConfiguration(
      bounds: CGRect(origin: .zero, size: frame.size),
      wireCount: 2,
      wireHistory: 5,
      colors: [.cyan, .orange]
    )
    wireState = State(configuration: wireConfiguration)

    super.init(frame: frame, isPreview: isPreview)

    wantsLayer = true
    layer?.backgroundColor = NSColor.black.cgColor
  }

  @available(*, unavailable)
  required init?(coder decoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func draw(_ rect: NSRect) {
    wireState.snapshots.forEach { snapshot in
      snapshot.wires.forEach { wire in
        wire.color.setStroke()
        wire.wirePath.stroke()
      }
    }
    setNeedsDisplay(rect)
   }

  override func animateOneFrame() {
    super.animateOneFrame()
    wireState = wireState.advance()
    setNeedsDisplay(bounds)
  }
}
