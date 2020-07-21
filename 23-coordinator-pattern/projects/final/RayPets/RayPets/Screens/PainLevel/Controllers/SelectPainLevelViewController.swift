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

// MARK: - SelectPainLevelViewControllerDelegate
public protocol SelectPainLevelViewControllerDelegate: class {
  func selectPainLevelViewController(_ controller: SelectPainLevelViewController,
                                     didSelect painLevel: PainLevel)
}

// MARK: - SelectPainLevelViewController
public class SelectPainLevelViewController: UIViewController {

  // MARK: - Instance Properties
  public weak var delegate: SelectPainLevelViewControllerDelegate?

  private var pageViewController: UIPageViewController!
  private let painLevelViewControllers =
    [
      PainLevelViewController.instantiate(description: "None at all",
                                          image: UIImage(named: "pain_level_none")!,
                                          painLevel: .none),

      PainLevelViewController.instantiate(description: "A little pain",
                                          image: UIImage(named: "pain_level_little")!,
                                          painLevel: .little),

      PainLevelViewController.instantiate(description: "Moderate pain",
                                          image: UIImage(named: "pain_level_moderate")!,
                                          painLevel: .moderate),

      PainLevelViewController.instantiate(description: "Severe pain!",
                                          image: UIImage(named: "pain_level_severe")!,
                                          painLevel: .severe),

      PainLevelViewController.instantiate(description: "Worst pain possible!!!",
                                          image: UIImage(named: "pain_level_worst_possible")!,
                                          painLevel: .worstPossible)
  ]

  // MARK: - View Lifecycle
  public override func viewDidLoad() {
    super.viewDidLoad()
    configurePageControl()
  }

  private func configurePageControl() {
    let pageControl = UIPageControl.appearance(whenContainedInInstancesOf: [SelectPainLevelViewController.self])
    pageControl.currentPageIndicatorTintColor = .black
    pageControl.pageIndicatorTintColor = .lightGray
  }

  // MARK: - Segues
  public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let pageViewController = segue.destination as? UIPageViewController else { return }
    pageViewController.setViewControllers([painLevelViewControllers.first!],
                                          direction: .forward,
                                          animated: false,
                                          completion: nil)
    pageViewController.dataSource = self
    self.pageViewController = pageViewController
  }

  // MARK: - Actions
  @IBAction internal func didPressOkayButton(_ sender: AnyObject) {
    let painViewController = pageViewController.viewControllers!.first! as! PainLevelViewController
    delegate?.selectPainLevelViewController(self, didSelect: painViewController.painLevel)
  }
}

// MARK: - UIPageViewControllerDataSource
extension SelectPainLevelViewController: UIPageViewControllerDataSource {

  public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
    guard let index = painLevelViewControllers.firstIndex(where: { $0 === viewController}),
      index > 0 else { return nil }
    return painLevelViewControllers[index - 1]
  }

  public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
    guard let index = painLevelViewControllers.firstIndex(where: { $0 === viewController}),
      index < painLevelViewControllers.count - 1 else { return nil }
    return painLevelViewControllers[index + 1]
  }

  public func presentationCount(for pageViewController: UIPageViewController) -> Int {
    return painLevelViewControllers.count
  }

  public func presentationIndex(for pageViewController: UIPageViewController) -> Int {
    guard let viewController = pageViewController.viewControllers?.first,
      let index = painLevelViewControllers.lastIndex(where: { $0 === viewController }) else {
        return 0
    }
    return index
  }
}

// MARK: - StoryboardInstantiable
extension SelectPainLevelViewController: StoryboardInstantiable {

  public class func instantiate(delegate: SelectPainLevelViewControllerDelegate) -> SelectPainLevelViewController {
    let viewController = instanceFromStoryboard()
    viewController.delegate = delegate
    return viewController
  }
}
