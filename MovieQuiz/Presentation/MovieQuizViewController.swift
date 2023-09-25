import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate, AlertPresenterDelegate {
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        questionFactory.delegate = self
        questionFactory.requestNextQuestion()
        alertPresenter.delegate = self
    }
    // MARK: - QuestionFactoryDelegate
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
               return
        }

        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
    // MARK: - QuestionFactoryDelegate
    func didShowAlert(alert: UIAlertController) {
        self.present(alert, animated: true)
    }
    
    
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol = QuestionFactory()
    private var currentQuestion: QuizQuestion?
    private var alertPresenter: AlertPresenterProtocol = AlertPresenter()
    private var statisticService: StatisticService = StatisticServiceImplementation()
    @IBOutlet private var imageView: UIImageView!
    
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var textLabel: UILabel!
    
    @IBOutlet private var yesButton: UIButton!
    
    @IBOutlet private var noButton: UIButton!
    @IBAction private func noButtonClicked(_ sender: Any) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        showAnswerResult(isCorrect: !currentQuestion.correctAnswer)
       
        
    }
    
    @IBAction private func yesButtonClicked(_ sender: Any) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        showAnswerResult(isCorrect: currentQuestion.correctAnswer)
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let questionStep = QuizStepViewModel( // 1
            image: UIImage(named: model.image) ?? UIImage(), // 2
            question: model.text, // 3
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)") // 4
        return questionStep
    }
    
    private func show(quiz step: QuizStepViewModel) {
        counterLabel.text = step.questionNumber
        textLabel.text = step.question
        imageView.image = step.image
        yesButton.isEnabled = true
        noButton.isEnabled = true
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        yesButton.isEnabled = false
        noButton.isEnabled = false
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        if isCorrect {
            correctAnswers += 1
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                guard let self = self else { return }
                self.showNextQuestionOrResults()
            }
    }
    
 
    private func showNextQuestionOrResults() {
        imageView.layer.borderWidth = 0
        if currentQuestionIndex == questionsAmount - 1 {
            statisticService.store(correct: correctAnswers, total: questionsAmount)
            let record = statisticService.bestGame
            let result = QuizResultsViewModel(title: "Этот раунд окончен!", text: "Ваш результат: \(correctAnswers)/10\nКоличество сыгранных квизов: \(statisticService.gamesCount)\nРекорд: \(record.correct)/\(record.total) (\(record.date.dateTimeString))\nСредняя точность: \(String(format: "%.2f", statisticService.totalAccurancy * 100.0))%", buttonText: "Сыграть ещё раз")
            show(quiz: result)
            
        } else {
            currentQuestionIndex += 1
            questionFactory.requestNextQuestion()
        }
    }
    
    
    private func show(quiz result: QuizResultsViewModel) {
        let alert = AlertModel(title: result.title, message: result.text, buttonText: result.buttonText, completion: { [weak self] in
            guard let self = self else { return }
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            self.questionFactory.requestNextQuestion()
        })
        alertPresenter.showAlert(model: alert)
       
    }
      
    

        
        
    
}




    



