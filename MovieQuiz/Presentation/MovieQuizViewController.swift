import UIKit

final class MovieQuizViewController: UIViewController, AlertPresenterDelegate, MovieQuizViewControllerProtocol{
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        alertPresenter.delegate = self
        presenter.viewController = self
    }
    
    // MARK: - AlertPresenterDelegate
    func didShowAlert(alert: UIAlertController) {
        self.present(alert, animated: true)
    }
    
    private let presenter = MovieQuizPresenter()
    private var alertPresenter: AlertPresenterProtocol = AlertPresenter()
    @IBOutlet private var imageView: UIImageView!
    
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var textLabel: UILabel!
    
    @IBOutlet private var yesButton: UIButton!
    
    @IBOutlet private var noButton: UIButton!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
   
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        presenter.yesButtonClicked()
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter.noButtonClicked()
    }
    
    func show(quiz step: QuizStepViewModel) {
        imageView.layer.borderWidth = 0
        counterLabel.text = step.questionNumber
        textLabel.text = step.question
        imageView.image = step.image
        yesButton.isEnabled = true
        noButton.isEnabled = true
    }
    
    
    func highlightImageBorder(isCorrectAnswer: Bool) {
        yesButton.isEnabled = false
        noButton.isEnabled = false
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
    }
    
 
    
    
    func show(quiz result: QuizResultsViewModel) {
        let alert = AlertModel(title: result.title, message: result.text, buttonText: result.buttonText, completion: { [weak self] in
            guard let self = self else { return }
            self.presenter.restartGame()
        })
        alertPresenter.showAlert(model: alert)
       
    }
    
    
   func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    
    func hideLoadingIndicator() {
        activityIndicator.isHidden = true
    }
      
    
    func showNetworkError(message: String){
        hideLoadingIndicator()
        let model = AlertModel(title: "Ошибка",
                                  message: message,
                                  buttonText: "Попробовать еще раз") { [weak self] in
                guard let self = self else { return }
                self.presenter.restartGame()
           }
           
           alertPresenter.showAlert(model: model)
    }
}




    



