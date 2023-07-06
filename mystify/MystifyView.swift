import ScreenSaver

class MystifyView: ScreenSaverView {

  override init?(frame: NSRect, isPreview: Bool) {
    super.init(frame: frame, isPreview: isPreview)

    wantsLayer = true
    layer?.backgroundColor = NSColor.cyan.cgColor
  }

  @available(*, unavailable)
  required init?(coder decoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func draw(_ rect: NSRect) {
    // draw it
  }

  override func animateOneFrame() {
    super.animateOneFrame()

    // update state
  }
}

