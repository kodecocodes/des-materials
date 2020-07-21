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

public class HowToCodeCoordinator: Coordinator {

  // MARK: - Instance Properties
  public var children: [Coordinator] = []
  public let router: Router

  private lazy var stepViewControllers = [
    StepViewController.instantiate(
      delegate: self,
      buttonColor: UIColor(red: 0.96, green: 0, blue: 0.11,
                           alpha: 1),
      text: "When I wake up, well, I'm sure I'm gonna be\n\n" +
      "I'm gonna be the one writin' code for you",
      title: "I wake up"),

    StepViewController.instantiate(
      delegate: self,
      buttonColor: UIColor(red: 0.93, green: 0.51, blue: 0.07,
                           alpha: 1),
      text: "When I go out, well, I'm sure I'm gonna be\n\n" +
      "I'm gonna be the one thinkin' bout code for you",
      title: "I go out"),

    StepViewController.instantiate(
      delegate: self,
      buttonColor: UIColor(red: 0.23, green: 0.72, blue: 0.11,
                           alpha: 1),
      text: "Cause' I would code five hundred lines\n\n" +
      "And I would code five hundred more",
      title: "500 lines"),

    StepViewController.instantiate(
      delegate: self,
      buttonColor: UIColor(red: 0.18, green: 0.29, blue: 0.80,
                           alpha: 1),
      text: "To be the one that wrote a thousand lines\n\n" +
      "To get this code shipped out the door!",
      title: "Ship it!")
  ]

  // 3
  private lazy var startOverViewController =
    StartOverViewController.instantiate(delegate: self)

  // MARK: - Object Lifecycle
  public init(router: Router) {
    self.router = router
  }

  // MARK: - Coordinator
  public func present(animated: Bool,
                      onDismissed: (() -> Void)?) {
    let viewController = stepViewControllers.first!
    router.present(viewController,
                   animated: animated,
                   onDismissed: onDismissed)
  }
}

// MARK: - StepViewControllerDelegate
extension HowToCodeCoordinator: StepViewControllerDelegate {
  
  public func stepViewControllerDidPressNext(
    _ controller: StepViewController) {
    if let viewController =
      stepViewController(after: controller) {
      router.present(viewController, animated: true)
    } else {
      router.present(startOverViewController, animated: true)
    }
  }
  
  private func stepViewController(after
    controller: StepViewController) -> StepViewController? {
    guard let index = stepViewControllers
      .firstIndex(where: { $0 === controller }),
      index < stepViewControllers.count - 1 else { return nil }
    return stepViewControllers[index + 1]
  }
}

// MARK: - StartOverViewControllerDelegate
extension HowToCodeCoordinator:
  StartOverViewControllerDelegate {

  public func startOverViewControllerDidPressStartOver(
    _ controller: StartOverViewController) {
    router.dismiss(animated: true)
  }
}
