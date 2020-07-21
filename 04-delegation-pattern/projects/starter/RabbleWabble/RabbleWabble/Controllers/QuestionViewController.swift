/// Copyright (c) 2019 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit

public class QuestionViewController: UIViewController {

  // MARK: - Instance Properties
  public var questionGroup = QuestionGroup.basicPhrases()
  public var questionIndex = 0
  
  public var correctCount = 0
  public var incorrectCount = 0
  
  public var questionView: QuestionView! {
    guard isViewLoaded else { return nil }
    return (view as! QuestionView)
  }
  
  // MARK: - View Lifecycle
  public override func viewDidLoad() {
    super.viewDidLoad()
    showQuestion()
  }
  
  private func showQuestion() {
    let question = questionGroup.questions[questionIndex]
    
    questionView.answerLabel.text = question.answer
    questionView.promptLabel.text = question.prompt
    questionView.hintLabel.text = question.hint
    
    questionView.answerLabel.isHidden = true
    questionView.hintLabel.isHidden = true
  }
  
  // MARK: - Actions
  @IBAction func toggleAnswerLabels(_ sender: Any) {
    questionView.answerLabel.isHidden =
      !questionView.answerLabel.isHidden
    questionView.hintLabel.isHidden =
      !questionView.hintLabel.isHidden
  }
  
  @IBAction func handleCorrect(_ sender: Any) {
    correctCount += 1
    questionView.correctCountLabel.text = "\(correctCount)"
    showNextQuestion()
  }
  
  @IBAction func handleIncorrect(_ sender: Any) {
    incorrectCount += 1
    questionView.incorrectCountLabel.text = "\(incorrectCount)"
    showNextQuestion()
  }
  
  private func showNextQuestion() {
    questionIndex += 1
    guard questionIndex < questionGroup.questions.count else {
      // TODO: - Handle this...!
      return
    }
    showQuestion()
  }
}
