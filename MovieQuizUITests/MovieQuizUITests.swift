
import XCTest

final class MovieQuizUITests: XCTestCase {
  
  var app: XCUIApplication!
  
  override func setUpWithError() throws {
    try super.setUpWithError()
    app = XCUIApplication()
    app.launch()

    continueAfterFailure = false
  }
  
  override func tearDownWithError() throws {
    try super.tearDownWithError()
   
    app.terminate()
    app = nil
  }
  
  func testYesButton() throws {
    let firstPoster = app.images["Poster"]
    let yesButton = app.buttons["Yes"]
    let indexLabel = app.staticTexts["Index"]
    
    yesButton.tap()
    let secondPoster = app.images["Poster"]
    
    sleep(3)
    
    XCTAssertTrue(indexLabel.label == "2/10")
    XCTAssertFalse(firstPoster == secondPoster)
  }
  
  func testNoButton() throws {
    let firstPoster = app.images["Poster"]
    let noButton = app.buttons["No"]
    let indexLabel = app.staticTexts["Index"]
    
    noButton.tap()
    let secondPoster = app.images["Poster"]
    
    sleep(3)
    
    XCTAssertTrue(indexLabel.label == "2/10")
    XCTAssertFalse(firstPoster == secondPoster)
    
  }
  
  func testGameFinish() throws {
    let yesButton = app.buttons["Yes"]
    for _ in Range(1...10) {
      yesButton.tap()
      sleep(1)
    }
    
    sleep(1)

    let alert = app.alerts["Этот раунд окончен!"]
    XCTAssertTrue(alert.exists)
    XCTAssertTrue(alert.label == "Этот раунд окончен!")
    XCTAssertTrue(alert.buttons.firstMatch.label == "Сыграть ещё раз")
  }
  
  func testAlertDismiss() throws {
    let yesButton = app.buttons["Yes"]
    for _ in Range(1...10) {
      yesButton.tap()
      sleep(1)
    }
    
    
    let alert = app.alerts["Этот раунд окончен!"]
    XCTAssertTrue(alert.exists)
    alert.buttons.firstMatch.tap()
    sleep(1)
    XCTAssertFalse(app.alerts["Этот раунд окончен!"].exists)
    sleep(1)
    let indexLabel = app.staticTexts["Index"]
    XCTAssertEqual(indexLabel.label, "1/10")
  }
  
}
