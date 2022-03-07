//
//  ViewController.swift
//  ElementQuiz
//
//  Created by SD on 21/02/2022.
//

import UIKit

enum Mode {
    case flashCard
    case quiz
}

enum State {
    case question
    case answer
    case score
}

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var modeSelector: UISegmentedControl!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var counter: UILabel!
    
    @IBAction func switchModes(_ sender: Any) {
        if modeSelector.selectedSegmentIndex == 0 {
                mode = .flashCard
            } else {
                mode = .quiz
            }
    }
    
    
    var mode: Mode = .flashCard {
        didSet {
            updateUI()
        }
    }
    
    var elementList = ["Carbon", "Gold", "Chlorine","Sodium", "Sulfer", "Dubnium", "Neon", "Moscovium", "Nitrogen", "Lead", "Iron", "Oxygen", "Chromium", "Magnesium", "Roentgenium", "Uranium", "Tennessine", "Platinum", "Potassium", "Zinc", "Krypton", "Cobalt", "Titanium", "Nickel", "Helium"]

    var state: State = .question

    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        elementList = elementList.shuffled()
        
        // Do any additional setup after loading the view.
    }
    
    
    var currentElementIndex = 0
    
    func updateFlashCardUI(elementName: String) {
        // Text field and keyboard
        textField.isHidden = true
        counter.isHidden = true
        textField.resignFirstResponder()
        // Answer label
        if state == .answer {
            answerLabel.text = elementName
        } else {
            answerLabel.text = "🤔"
        }
        modeSelector.selectedSegmentIndex = 0
    }
    
    @IBAction func showAnswer(_ sender: Any) {
        state = .answer
        updateUI()

    }
    
    @IBAction func next(_ sender: Any) {
        currentElementIndex += 1
            if currentElementIndex >= elementList.count
            {
                currentElementIndex = 0
                if mode == .quiz {
                    state = .score
                    updateUI()
                return
            }
        }

            state = .question
            updateUI()
    }
    
    func updateQuizUI(elementName: String) {
        // Text field and keyboard
        textField.isHidden = false
        switch state {
        case .question:
            counter.text =  "\(currentElementIndex+1) / \(elementList.count)"
            counter.isHidden = false
            textField.isEnabled = true
            textField.text = ""
            textField.becomeFirstResponder()
        case .answer:
            textField.isEnabled = false
            textField.resignFirstResponder()
        case .score:
            textField.isEnabled = true
            textField.isHidden = true
            textField.resignFirstResponder()
        if state == .score {
                displayScoreAlert()
            }
        }
        // Answer label
        switch state {
        case .question:
            answerLabel.text = ""
        case .answer:
            if answerIsCorrect {
                answerLabel.text = "Correct!"
            } else {
                answerLabel.text = "❌\nCorrect Answer: " + elementName
            }
            case .score:
                answerLabel.text = ""
                print("Your score is \(correctAnswerCount) out of \(elementList.count).")
        }
        modeSelector.selectedSegmentIndex = 1
    }

    func updateUI() {
        // Shared code: updating the image
        let elementName =
           elementList[currentElementIndex]
        let image = UIImage(named: elementName)
        imageView.image = image
        
        switch mode {
        case .flashCard:
            updateFlashCardUI(elementName: elementName)
        case .quiz:
            updateQuizUI(elementName: elementName)
        }
    }

    var answerIsCorrect = false
    var correctAnswerCount = 0
    
    func textFieldShouldReturn(_ textField:UITextField) -> Bool {

        let textFieldContents = textField.text!
    
        if textFieldContents.lowercased() == elementList[currentElementIndex].lowercased() {
            answerIsCorrect = true
            correctAnswerCount += 1
        } else {
            answerIsCorrect = false
        }
        state = .answer
        updateUI()
        return true
    }
    
    func displayScoreAlert() {
        let alert = UIAlertController(title:"Quiz Score",message: "Your score is \(correctAnswerCount) out of \(elementList.count).",preferredStyle: .alert)
        let dismissAction =
           UIAlertAction(title: "👍🏻",
           style: .default, handler:
           scoreAlertDismissed(_:))
        alert.addAction(dismissAction)
        present(alert, animated: true,
           completion: nil)
    }
    func scoreAlertDismissed(_ action: UIAlertAction) {
        mode = .flashCard
        state = .question
        currentElementIndex = 0
        answerIsCorrect = false
        correctAnswerCount = 0
        elementList = elementList.shuffled()
    }
}




