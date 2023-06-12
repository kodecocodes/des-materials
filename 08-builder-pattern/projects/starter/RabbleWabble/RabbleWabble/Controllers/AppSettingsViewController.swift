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

public class AppSettingsViewController: UITableViewController {

  // MARK: - Properties
  public let appSettings = AppSettings.shared
  private let cellIdentifier = "basicCell"
  
  // MARK: - View Life Cycle
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.tableFooterView = UIView()
    tableView.register(UITableViewCell.self,
                       forCellReuseIdentifier: cellIdentifier)
  }
}

// MARK: - UITableViewDataSource
extension AppSettingsViewController {
  
  public override func tableView(_ tableView: UITableView,
                                 numberOfRowsInSection section: Int) -> Int {
    return QuestionStrategyType.allCases.count
  }
  
  public override func tableView(_ tableView: UITableView,
                                 cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(
      withIdentifier: cellIdentifier, for: indexPath)
    
    let questionStrategyType = QuestionStrategyType.allCases[indexPath.row]
    
    cell.textLabel?.text = questionStrategyType.title()
    if appSettings.questionStrategyType == questionStrategyType {
      cell.accessoryType = .checkmark
    } else {
      cell.accessoryType = .none
    }
    return cell
  }
}

// MARK: - UITableViewDelegate
extension AppSettingsViewController {
  public override func tableView( _ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let questionStrategyType = QuestionStrategyType.allCases[indexPath.row]
    appSettings.questionStrategyType = questionStrategyType
    tableView.reloadData()
  }
}
