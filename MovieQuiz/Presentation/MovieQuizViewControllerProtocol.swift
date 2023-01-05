
protocol MovieQuizViewControllerProtocol: AnyObject {
  func showNetworkError(message: String)
  func hideLoadingIndicator()
  func showNextQuestion(quiz: QuizStepViewModel)
  func showLoadingIndicator()
  func setButtonsAvailability(_ value: Bool)
  func showResults(quiz: QuizResultsViewModel)
  func showAnswerResult(_ answerIsCorrect: Bool)
}
