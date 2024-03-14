import UIKit

final class MovieQuizViewController: UIViewController {
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
        
    private let questions: [QuizQuestion] = [
        QuizQuestion(image: "The Godfather", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
        QuizQuestion(image: "The Dark Knight", text: "Рейтинг этого фильма больше 6?", correctAnswer: true),
        QuizQuestion(image: "Kill Bill", text: "Рейтинг этого фильма больше 6?", correctAnswer: true),
        QuizQuestion(image: "The Avengers", text: "Рейтинг этого фильма больше 6?", correctAnswer: true),
        QuizQuestion(image: "Deadpool", text: "Рейтинг этого фильма больше 6?", correctAnswer: true),
        QuizQuestion(image: "The Green Knight", text: "Рейтинг этого фильма больше 6?", correctAnswer: true),
        QuizQuestion(image: "Old", text: "Рейтинг этого фильма больше 6?", correctAnswer: false),
        QuizQuestion(image: "The Ice Age Adventures of Buck Wild", text: "Рейтинг этого фильма больше 6?", correctAnswer: false),
        QuizQuestion(image: "Tesla", text: "Рейтинг этого фильма больше 6?", correctAnswer: false),
        QuizQuestion(image: "Vivarium", text: "Рейтинг этого фильма больше 6?", correctAnswer: false)]
    override func viewDidLoad() {
        let currentQuestion = questions[currentQuestionIndex]
        let viewModel = convert(model: currentQuestion )
        show(quiz: viewModel)
    }
    //Я делаю статус бар белым, но нижний вью контроллер все равно серый, весь интернет перерыл, как его сделать белым?
    override var preferredStatusBarStyle: UIStatusBarStyle {
          return .lightContent
    }
    
    @IBAction private func yesButtonClicked(_ sender: Any) {
        let currentQuestion = questions[currentQuestionIndex]
        let givenAnswer = true
            
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    @IBAction private func noButtonClicked(_ sender: Any) {
        let currentQuestion = questions[currentQuestionIndex]
        let givenAnswer = false
            
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    //метод конвертации, мы берем моковые данные и преобразуем во вью вопроса
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let questionStep = QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questions.count)")
        return questionStep
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            correctAnswers += 1
        }
        
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        imageView.layer.cornerRadius = 10
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
           // код, который мы хотим вызвать через 1 секунду
           self.showNextQuestionOrResults()
            self.noBorder()
        }
    }
    
    private func noBorder() {
        imageView.layer.borderWidth = 0
    }
    //метод показа show
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.font = UIFont(name: "YSDisplay-Bold", size: 23)
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    // метода показа результата
    private func show(quiz result: QuizResultsViewModel) {
        let alert = UIAlertController(title: result.title, message: result.text, preferredStyle: .alert)
        let action = UIAlertAction(title: result.buttonText, style: .default) { _ in
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            
            let firstQuestion = self.questions[self.currentQuestionIndex]
            let viewModel = self.convert(model: firstQuestion)
            self.show(quiz: viewModel)
        }
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
    }
    //метод перехода к следубщему вопросу после ответа
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questions.count - 1 {
            let text = "Ваш результат: \(correctAnswers)/\(questions.count)"
            let viewModel = QuizResultsViewModel(title: "Этот раунд окончен", text: text, buttonText: "Сыграем ещё раз")
            show(quiz: viewModel)
        } else {
            currentQuestionIndex += 1
            // переходим к следующему вопросу
            let nextQuestion = questions[currentQuestionIndex]
            let viewModel = convert(model: nextQuestion )
            show(quiz: viewModel)
        }
    }
}

    //Структура вопроса
    struct QuizQuestion {
        let image: String
        //строка с вопросом о рейтинге филтма
        let text: String
        let correctAnswer: Bool
    }
    //Вью модель для состояния "Вопрос показан"
    struct QuizStepViewModel {
        let image: UIImage
        let question: String
        let questionNumber: String
    }
    //Вью модель для состояния "Результат Квиза"
    struct QuizResultsViewModel {
        let title: String
        let text: String
        let buttonText: String
    }
    //Вью модель для состояния "Результат Ответа"
    struct QuizAnswer {
        let result: Bool
    }
