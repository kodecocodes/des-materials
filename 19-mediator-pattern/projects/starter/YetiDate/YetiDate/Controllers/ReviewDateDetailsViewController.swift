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
import YelpAPI

public protocol ReviewDateDetailsViewControllerDelegate {
  func reviewDateDetailsViewControllerDone(_ controller: ReviewDateDetailsViewController)
}

public class ReviewDateDetailsViewController: UIViewController {

  // MARK: - Instance Properties
  public var delegate: ReviewDateDetailsViewControllerDelegate?

  public var categoryToBusinessDict: [YelpCategory: YLPBusiness]!
  public lazy var tableViewModels: [BusinessTableViewModel] = {
    return categoryToBusinessDict.map { category, business in
      BusinessTableViewModel(business: business, primaryCategory: category)
      }.sorted(by: { $0.primaryCategory < $1.primaryCategory })
  }()

  // MARK: - Class Constructors
  public class func instanceFromStoryboard(
    with categoryToBusinessDict: [YelpCategory: YLPBusiness],
    delegate: ReviewDateDetailsViewControllerDelegate) -> ReviewDateDetailsViewController {
    let storyboard = UIStoryboard(name: "Main", bundle: .main)
    let identifier = "ReviewDateDetailsViewController"
    let viewController = storyboard.instantiateViewController(withIdentifier: identifier)
      as! ReviewDateDetailsViewController
    viewController.categoryToBusinessDict = categoryToBusinessDict
    viewController.delegate = delegate
    return viewController
  }

  // MARK: - IBOutlets
  @IBOutlet public var tableView: UITableView! {
    didSet {
      tableView.tableFooterView = UIView()
      tableView.rowHeight = UITableView.automaticDimension
      tableView.estimatedRowHeight = 102
    }
  }

  // MARK: - Actions
  @IBAction func donePressed(_ sender: Any) {
    delegate?.reviewDateDetailsViewControllerDone(self)
  }
}

// MARK: - UITableViewDataSource
extension ReviewDateDetailsViewController: UITableViewDataSource {

  public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return tableViewModels.count
  }

  public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let identifier = "BusinessTableViewCell"
    let viewModel = tableViewModels[indexPath.row]
    let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as! BusinessTableViewCell
    viewModel.configure(cell)
    return cell
  }
}

// MARK: - UITableViewDelegate
extension ReviewDateDetailsViewController: UITableViewDelegate {

  public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
}
