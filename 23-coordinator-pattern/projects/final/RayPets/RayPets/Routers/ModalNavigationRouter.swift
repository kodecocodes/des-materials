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

public class ModalNavigationRouter: NSObject {

  // MARK: - Instance Properties
  public unowned let parentViewController: UIViewController

  private let navigationController = UINavigationController()
  private var onDismissForViewController:
    [UIViewController: (() -> Void)] = [:]

  // MARK: - Object Lifecycle
  public init(parentViewController: UIViewController) {
    self.parentViewController = parentViewController
    super.init()
    navigationController.delegate = self
  }
}

// MARK: - Router
extension ModalNavigationRouter: Router {

  public func present(_ viewController: UIViewController,
                      animated: Bool,
                      onDismissed: (() -> Void)?) {
    onDismissForViewController[viewController] = onDismissed
    if navigationController.viewControllers.count == 0 {
      presentModally(viewController, animated: animated)
    } else {
      navigationController.pushViewController(
        viewController, animated: animated)
    }
  }

  private func presentModally(
    _ viewController: UIViewController,
    animated: Bool) {
    addCancelButton(to: viewController)
    navigationController.setViewControllers(
      [viewController], animated: false)
    parentViewController.present(navigationController,
                                 animated: animated,
                                 completion: nil)
  }

  private func addCancelButton(to
    viewController: UIViewController) {
    viewController.navigationItem.leftBarButtonItem =
    UIBarButtonItem(title: "Cancel",
                    style: .plain,
                    target: self,
                    action: #selector(cancelPressed))
  }

  @objc private func cancelPressed() {
    performOnDismissed(for:
      navigationController.viewControllers.first!)
    dismiss(animated: true)
  }

  public func dismiss(animated: Bool) {
    performOnDismissed(for:
      navigationController.viewControllers.first!)
    parentViewController.dismiss(animated: animated,
                                 completion: nil)
  }

  private func performOnDismissed(for
    viewController: UIViewController) {
    guard let onDismiss =
      onDismissForViewController[viewController] else { return }
    onDismiss()
    onDismissForViewController[viewController] = nil
  }
}

// MARK: - UINavigationControllerDelegate
extension ModalNavigationRouter:
  UINavigationControllerDelegate {

  public func navigationController(
    _ navigationController: UINavigationController,
    didShow viewController: UIViewController,
    animated: Bool) {

    guard let dismissedViewController =
      navigationController.transitionCoordinator?
        .viewController(forKey: .from),
      !navigationController.viewControllers
        .contains(dismissedViewController) else {
      return
    }
    performOnDismissed(for: dismissedViewController)
  }
}
