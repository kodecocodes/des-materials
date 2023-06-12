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

public class SelectQuestionGroupViewController: UIViewController {
  
  // MARK: - Outlets
  @IBOutlet internal var tableView: UITableView! {
    didSet {
      tableView.tableFooterView = UIView()
    }
  }
  
  // MARK: - Properties
  private let questionGroupCaretaker = QuestionGroupCaretaker()
  private var questionGroups: [QuestionGroup] {
    return questionGroupCaretaker.questionGroups
  }
  private var selectedQuestionGroup: QuestionGroup! {
    get { return questionGroupCaretaker.selectedQuestionGroup }
    set { questionGroupCaretaker.selectedQuestionGroup = newValue }
  }
  private let appSettings = AppSettings.shared
  
  // MARK: - View Lifecycle
  public override func viewDidLoad() {
    super.viewDidLoad()
    questionGroups.forEach {
      print("\($0.title): " +
        "correctCount \($0.score.correctCount), " +
        "incorrectCount \($0.score.incorrectCount)"
      )
    }
  }
}

// MARK: - UITableViewDataSource
extension SelectQuestionGroupViewController: UITableViewDataSource {
  
  public func tableView(_ tableView: UITableView,
                        numberOfRowsInSection section: Int)
    -> Int {
      return questionGroups.count
  }
  
  public func tableView(_ tableView: UITableView,
                        cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionGroupCell") as! QuestionGroupCell
    let questionGroup = questionGroups[indexPath.row]
    cell.titleLabel.text = questionGroup.title
    cell.percentageSubscriber =
      questionGroup.score.$runningPercentage
        .receive(on: DispatchQueue.main)
        .map() {
          return String(format: "%.0f %%", round(100 * $0))
      }.assign(to: \.text, on: cell.percentageLabel)
    return cell
  }
}

extension SelectQuestionGroupViewController: UITableViewDelegate {
  
  public func tableView(_ tableView: UITableView,
                        willSelectRowAt indexPath: IndexPath) -> IndexPath? {
      selectedQuestionGroup = questionGroups[indexPath.row]
      return indexPath
  }
  
  public func tableView(_ tableView: UITableView,
                        didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  public override func prepare(
    for segue: UIStoryboardSegue, sender: Any?) {
    if let viewController =
      segue.destination as? QuestionViewController {
      viewController.questionStrategy =
        appSettings.questionStrategy(for: questionGroupCaretaker)
      viewController.delegate = self

    } else if let navController =
        segue.destination as? UINavigationController,
      let viewController =
        navController.topViewController as? CreateQuestionGroupViewController {
      viewController.delegate = self
    }
    // Whatevs... skip anything else
  }
}

// MARK: - QuestionViewControllerDelegate
extension SelectQuestionGroupViewController: QuestionViewControllerDelegate {
  public func questionViewController(
    _ viewController: QuestionViewController,
    didCancel questionGroup: QuestionStrategy) {
    navigationController?.popToViewController(self,
                                              animated: true)
  }
  
  public func questionViewController(
    _ viewController: QuestionViewController,
    didComplete questionGroup: QuestionStrategy) {
    navigationController?.popToViewController(self,
                                              animated: true)
  }
}

// MARK: - CreateQuestionGroupViewControllerDelegate
extension SelectQuestionGroupViewController: CreateQuestionGroupViewControllerDelegate {

  public func createQuestionGroupViewControllerDidCancel(
    _ viewController: CreateQuestionGroupViewController) {
    dismiss(animated: true, completion: nil)
  }

  public func createQuestionGroupViewController(
    _ viewController: CreateQuestionGroupViewController,
    created questionGroup: QuestionGroup) {

    questionGroupCaretaker.questionGroups.append(questionGroup)
    try? questionGroupCaretaker.save()

    dismiss(animated: true, completion: nil)
    tableView.reloadData()
  }
}
