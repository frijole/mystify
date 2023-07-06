import mystify
import XCTest

final class MystifyTests: XCTestCase {

  override func setUp() {  }
  override func tearDown() {  }

  func test_init() {
    let configuration = WireConfiguration.default()
    let state = State(configuration: configuration)

    XCTAssertEqual(state.bounds, CGRect(x: 0, y: 0, width: 1024, height: 768))
    XCTAssertEqual(state.snapshots.count, 1)
  }

  func test_advance() {
    let state = State(configuration: .default())
    XCTAssertEqual(state.snapshots.count, 1, "Precondition")

    let newState = state.advance()
    XCTAssertEqual(newState.snapshots.count, 2)
  }

  func test_advance_moreThanFiveTimes() {
    let configuration = WireConfiguration.default()
    let state = State(configuration: configuration)
    XCTAssertEqual(state.snapshots.count, 1, "Precondition")

    let newState = state
      .advance()
      .advance()
      .advance()
      .advance()
      .advance()
      .advance()
      .advance()
    XCTAssertEqual(
      newState.snapshots.count,
      configuration.wireHistory
    )
  }


}

/// Things

extension WireConfiguration {
  static func `default`() -> WireConfiguration {
    WireConfiguration(
      bounds: CGRect(x: 0, y: 0, width: 1024, height: 768),
      wireCount: 2,
      wireHistory: 5,
      colors: [.cyan, .yellow]
    )
  }
}
