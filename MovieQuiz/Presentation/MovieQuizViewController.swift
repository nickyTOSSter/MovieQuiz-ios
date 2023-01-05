import UIKit

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol {
  // MARK: - Outlets
  @IBOutlet private weak var imageView: UIImageView!
  @IBOutlet private weak var textLabel: UILabel!
  @IBOutlet private weak var counterLabel: UILabel!
  @IBOutlet private weak var questionLabel: UILabel!
  @IBOutlet private weak var yesButton: UIButton!
  @IBOutlet private weak var noButton: UIButton!
  @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
  
  // MARK: - Properties
  private var alertPresenter: AlertPresenter!
  private var presenter: MovieQuizPresenter!
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    imageView.layer.cornerRadius = 20
    setFonts()
    
    alertPresenter = AlertPresenter()
    alertPresenter.delegate = self
  
    presenter = MovieQuizPresenter(viewController: self)
  }
  
  // MARK: - Actions
  @IBAction private func noButtonClicked(_ sender: UIButton) {
    presenter.noButtonClicked()
  }
  
  @IBAction private func yesButtonClicked(_ sender: UIButton) {
    presenter.yesButtonClicked()
  }
  
  // MARK: - Private functions
  func showNextQuestion(quiz step: QuizStepViewModel) {
    imageView.layer.borderWidth = 0
    imageView.image = step.image
    textLabel.text = step.question
    counterLabel.text = step.questionNumber
  }
  
  func showResults(quiz result: QuizResultsViewModel) {
    let alertModel = AlertModel(title: result.title, message: result.text, buttonText: result.buttonText) { [weak self] _ in
      guard let self = self else {
        return
      }
      self.presenter.restartGame()
    }
    alertPresenter.show(alertModel: alertModel)
  }
    
  func showAnswerResult(_ answerIsCorrect: Bool) {
    imageView.layer.masksToBounds = true
    imageView.layer.borderWidth = 8
    imageView.layer.borderColor = answerIsCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
    
    setButtonsAvailability(false)
  }
     
  func showNetworkError(message: String) {
    hideLoadingIndicator()
    let model = AlertModel(title: "Ошибка", message: message, buttonText: "Попробовать еще раз") { [weak self] _ in
      guard let self = self else {
        return
      }
      self.presenter.loadData()
    }
    alertPresenter.show(alertModel: model)
  }
    
  private func setFonts() {
    textLabel.font = UIFont.ysDisplayBold.withSize(23)
    counterLabel.font = UIFont.ysDisplayMedium
    questionLabel.font = UIFont.ysDisplayMedium
    yesButton.titleLabel?.font = UIFont.ysDisplayMedium
    noButton.titleLabel?.font = UIFont.ysDisplayMedium
  }
  
  func setButtonsAvailability(_ value: Bool) {
    yesButton.isEnabled = value
    noButton.isEnabled = value
  }
 
  func showLoadingIndicator() {
    activityIndicator.isHidden = false
    activityIndicator.startAnimating()
  }
  
  func hideLoadingIndicator() {
    activityIndicator.isHidden = true
  }

}


// MARK: - AlertPresenterDelegate
extension MovieQuizViewController: AlertPresenterDelegate {
  func presentQuizResults(_ alert: UIAlertController) {
    DispatchQueue.main.async { [weak self] in
      guard let self = self else { return }
      self.present(alert, animated: true, completion: nil)
    }
  }
}
