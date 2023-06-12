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

public class GameplayViewController: UIViewController {

  // MARK: - Outlets
  public var gameplayView: GameplayView {
    return view as! GameplayView
  }

  // MARK: - Instance Properties
  public private(set) var gameManager: GameManager!

  // MARK: - View Lifecycle
  public override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    guard isFirstTimeViewDidAppear else { return }
    isFirstTimeViewDidAppear = false
    presentSettingsViewController(animated: false)
  }
  private var isFirstTimeViewDidAppear = true

  // MARK: - Actions
  @IBAction func playReadyPressed(_ sender: Any) {
    gameManager.handleActionPressed()
  }

  @IBAction func undoPressed(_ sender: Any) {
    gameManager.handleUndoPressed()
  }

  @IBAction func settingsPressed(_ sender: Any) {
    presentSettingsViewController(animated: true)
  }

  private func presentSettingsViewController(animated: Bool) {
    let viewController = SettingsViewController.instanceFromStoryboard(withDelegate: self)
    present(viewController, animated: animated)
  }
}

// MARK: - GameboardViewDelegate
extension GameplayViewController: GameboardViewDelegate {

  public func gameboardView(_ gameboardView: GameboardView,
                            didSelectPosition position: GameboardPosition) {
    gameManager.addMove(at: position)
  }
}

// MARK: - SelectGameModeViewControllerDelegate
extension GameplayViewController: SettingsViewControllerDelegate {

  public func selectGameModeViewController(_ viewController: SettingsViewController,
                                           didSelectManager manager: GameManager) {
    gameManager = manager
    manager.gameplayView = gameplayView
    manager.newGame()
    dismiss(animated: true)
  }
}
