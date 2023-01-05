
import UIKit

final class MovieQuizPresenter {
  private weak var viewController: MovieQuizViewControllerProtocol!
  private let statisticService: StatisticService!
  private var questionFactory: QuestionFactoryProtocol!
  private var currentQuestion: QuizQuestion?
  
  let questionsAmount = 10
  private var currentQuestionIndex = 0
  private var correctAnswers = 0

  init(viewController: MovieQuizViewControllerProtocol) {
    self.viewController = viewController
    statisticService = StatisticServiceImplementation()
    questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
    loadData()
  }
  
  func yesButtonClicked() {
    didAnswer(isYes: true)
  }
  
  func noButtonClicked() {
    didAnswer(isYes: false)
  }

  private func didAnswer(isYes: Bool) {
    guard let currentQuestion = currentQuestion else {
      return
    }
    let givenAnswer = isYes
    let answerIsCorrect = givenAnswer == currentQuestion.correctAnswer
    if answerIsCorrect {
      correctAnswers += 1
    }
    viewController.showAnswerResult(answerIsCorrect)
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
      guard let self = self else { return }
      self.proceedNextQuestionOrResults()
    }
  }

  private func proceedNextQuestionOrResults() {
    if isLastQuestion() {
      statisticService.store(correct: correctAnswers, total: questionsAmount)
      let bestGame = statisticService.bestGame
      let text = """
      Ваш результат: \(correctAnswers)/10
      Количество сыгранных квизов: \(statisticService.gamesCount)
      Рекорд: \(bestGame.correct)/\(bestGame.total) (\(bestGame.date.dateTimeString))
      Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%
      """

      let viewModel = QuizResultsViewModel(
        title: "Этот раунд окончен!",
        text: text,
        buttonText: "Сыграть ещё раз")
      viewController.showResults(quiz: viewModel)
    } else {
      switchToNextQuestion()
      questionFactory.requestNextQuestion()
    }
    viewController.setButtonsAvailability(true)
  }

  
  func convert(model: QuizQuestion) -> QuizStepViewModel {
    return QuizStepViewModel(
      image: UIImage(data: model.image) ?? UIImage(),
      question: model.text,
      questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)"
    )
  }
  
  func isLastQuestion() -> Bool {
    currentQuestionIndex == questionsAmount - 1
  }
  
  func restartGame() {
    currentQuestionIndex = 0
    correctAnswers = 0
    questionFactory.requestNextQuestion()
  }
  
  func switchToNextQuestion() {
    currentQuestionIndex += 1
  }

  func loadData() {
    questionFactory.loadData()
    viewController.showLoadingIndicator()
  }
  
}

// MARK: - QuestionFactoryDelegate
extension MovieQuizPresenter: QuestionFactoryDelegate {
  
  func didRecieveNextQuestion(question: QuizQuestion?) {
    guard let question = question else {
      return
    }
    
    currentQuestion = question
    let viewModel = self.convert(model: question)
    DispatchQueue.main.async { [weak self] in
      guard let self = self else { return }
      self.viewController.showNextQuestion(quiz: viewModel)
    }
  }

  func didFailToLoadData(with error: Error) {
    viewController.showNetworkError(message: error.localizedDescription)
  }
  
  func didLoadDataFromServer() {
    viewController.hideLoadingIndicator()
    questionFactory.requestNextQuestion()
  }
}


