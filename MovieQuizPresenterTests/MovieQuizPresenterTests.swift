
import XCTest
@testable import MovieQuiz

final class MovieQuizViewControllerPortocolMock: MovieQuizViewControllerProtocol {
  func showNetworkError(message: String) {
  }
  
  func hideLoadingIndicator() {
  }
  
  func showNextQuestion(quiz: QuizStepViewModel) {
  }
  
  func showLoadingIndicator() {
  }
  
  func setButtonsAvailability(_ value: Bool) {
  }
  
  func showResults(quiz: QuizResultsViewModel) {
  }
  
  func showAnswerResult(_ answerIsCorrect: Bool) {
  }
  
}

final class MovieQuizPresenterTests: XCTestCase {

  func testPresenterConvertModel() throws {
    let viewController = MovieQuizViewControllerPortocolMock()
    let presenter = MovieQuizPresenter(viewController: viewController)

    let emptyData = Data()
    let question = QuizQuestion(image: emptyData, text: "Question Text", correctAnswer: true)
    let viewModel = presenter.convert(model: question)

    XCTAssertNotNil(viewModel.image)
    XCTAssertEqual(viewModel.question, "Question Text")
    XCTAssertEqual(viewModel.questionNumber, "1/10")
  }

}
