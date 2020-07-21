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

public class DecryptViewController: UIViewController {

  // MARK: - Instance Properties
  public let passwordClient = PasswordClient()
  public let secretMessageCaretaker = SecretMessageCareTaker()

  // MARK: - Outlets
  @IBOutlet public var tableView: UITableView! {
    didSet {
      tableView.estimatedRowHeight = 67
      tableView.rowHeight = UITableView.automaticDimension
    }
  }
}

// MARK: - Segue Management
extension DecryptViewController {

  public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let viewController = segue.destination as? PasswordViewController else { return }
    viewController.passwordClient = passwordClient
  }
}

// MARK: - UITableViewDataSource
extension DecryptViewController: UITableViewDataSource {

  public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return secretMessageCaretaker.messages.count
  }

  public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    let secretMessage = secretMessageCaretaker.messages[indexPath.row]
    let cell = tableView.dequeueReusableCell(withIdentifier: "SecretMessageCell") as! SecretMessageCell
    cell.configure(with: secretMessage)
    return cell
  }
}

// MARK: - UITableViewDelegate
extension DecryptViewController: UITableViewDelegate {

  public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)

    let secretMessage = secretMessageCaretaker.messages[indexPath.row]
    guard secretMessage.decrypted == nil else { return }

    secretMessage.decrypted = passwordClient.decrypt(secretMessage.encrypted)
    guard secretMessage.decrypted != nil else {
      print("Decryption failed!")
      return
    }
    tableView.reloadRows(at: [indexPath], with: .automatic)
  }
}
