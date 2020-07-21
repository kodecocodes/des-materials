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

public protocol CreateQuestionGroupViewControllerDelegate {

  func createQuestionGroupViewControllerDidCancel(_ viewController: CreateQuestionGroupViewController)

  func createQuestionGroupViewController(_ viewController: CreateQuestionGroupViewController,
                                         created questionGroup: QuestionGroup)
}

public class CreateQuestionGroupViewController: UITableViewController {

  // MARK: - Properties
  public var delegate: CreateQuestionGroupViewControllerDelegate?
  public let questionGroupBuilder = QuestionGroupBuilder()

  public override func viewDidLoad() {
    super.viewDidLoad()
    tableView.tableFooterView = UIView()
  }

  // MARK: - IBActions
  @IBAction func cancelPressed(_ sender: Any) {
    delegate?.createQuestionGroupViewControllerDidCancel(self)
  }

  @IBAction func savePressed(_ sender: Any) {
    do {
      let questionGroup = try questionGroupBuilder.build()
      delegate?.createQuestionGroupViewController(
        self, created: questionGroup)

    } catch {
      displayMissingInputsAlert()
    }
  }

  public func displayMissingInputsAlert() {
    let alert = UIAlertController(
      title: "Missing Inputs",
      message: "Please provide all non-optional values",
      preferredStyle: .alert)

    let okAction = UIAlertAction(title: "Ok",
                                 style: .default,
                                 handler: nil)
    alert.addAction(okAction)
    present(alert, animated: true, completion: nil)
  }
}

// MARK: - UITableViewDataSource
extension CreateQuestionGroupViewController {

  fileprivate struct CellIdentifiers {
    fileprivate static let add = "AddQuestionCell"
    fileprivate static let title = "CreateQuestionGroupTitleCell"
    fileprivate static let question = "CreateQuestionCell"
  }

  public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return questionGroupBuilder.questions.count + 2
  }

  public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let row = indexPath.row
    if row == 0 {
      return titleCell(from: tableView, for: indexPath)
    } else if row >= 1 &&
      row <= questionGroupBuilder.questions.count {
      return self.questionCell(from: tableView, for: indexPath)
    } else {
      return addQuestionGroupCell(from: tableView, for: indexPath)
    }
  }

  private func titleCell(from tableView: UITableView,
                         for indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.title,
                                             for: indexPath) as! CreateQuestionGroupTitleCell
    cell.delegate = self
    cell.titleTextField.text = questionGroupBuilder.title
    return cell
  }

  private func  questionCell(from tableView: UITableView,
                             for indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.question,
                                             for: indexPath) as! CreateQuestionCell
    cell.delegate = self
    let questionBuilder = self.questionBuilder(for: indexPath)
    cell.delegate = self
    cell.answerTextField.text = questionBuilder.answer
    cell.hintTextField.text = questionBuilder.hint
    cell.indexLabel.text = "Question \(indexPath.row)"
    cell.promptTextField.text = questionBuilder.prompt
    return cell
  }
  
  private func questionBuilder(for indexPath: IndexPath) -> QuestionBuilder {
    return questionGroupBuilder.questions[indexPath.row - 1]
  }

  private func addQuestionGroupCell(from tableView: UITableView,
                                    for indexPath: IndexPath) -> UITableViewCell {
    return tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.add,
                                         for: indexPath)
  }
}

// MARK: - UITableViewDelegate
extension CreateQuestionGroupViewController {

  public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    guard isLastIndexPath(indexPath) else { return }
    questionGroupBuilder.addNewQuestion()
    tableView.insertRows(at: [indexPath], with: .top)
  }

  private func isLastIndexPath(_ indexPath: IndexPath) -> Bool {
    return indexPath.row ==
      tableView.numberOfRows(inSection: indexPath.section) - 1
  }
}

// MARK: - CreateQuestionCellDelegate
extension CreateQuestionGroupViewController: CreateQuestionCellDelegate {

  public func createQuestionCell(_ cell: CreateQuestionCell,
                                 answerTextDidChange text: String) {
    questionBuilder(for: cell).answer = text
  }
  
  private func questionBuilder(for cell: CreateQuestionCell) -> QuestionBuilder  {
    let indexPath = tableView.indexPath(for: cell)!
    return questionBuilder(for: indexPath)
  }

  public func createQuestionCell(_ cell: CreateQuestionCell,
                                 hintTextDidChange text: String) {
    questionBuilder(for: cell).hint = text
  }

  public func createQuestionCell(_ cell: CreateQuestionCell,
                                 promptTextDidChange text: String) {
    questionBuilder(for: cell).prompt = text
  }
}

// MARK: - CreateQuestionGroupTitleCellDelegate
extension CreateQuestionGroupViewController: CreateQuestionGroupTitleCellDelegate {

  public func createQuestionGroupTitleCell(_ cell: CreateQuestionGroupTitleCell,
                                           titleTextDidChange text: String) {
    questionGroupBuilder.title = text
  }
}
