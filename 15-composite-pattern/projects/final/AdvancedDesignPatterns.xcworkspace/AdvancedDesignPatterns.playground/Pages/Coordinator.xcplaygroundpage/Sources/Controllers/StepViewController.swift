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

// MARK: - StepViewControllerDelegate
public protocol StepViewControllerDelegate: class {
  func stepViewControllerDidPressNext(_ controller: StepViewController)
}

// MARK: - StepViewController
public class StepViewController: UIViewController {
  
  // MARK: - Instance Properties
  public var delegate: StepViewControllerDelegate?
  
  private var buttonColor: UIColor!
  private var text: String!
  
  // MARK: - Views
  private var button: UIButton!
  private var label: UILabel!
  
  // MARK: - View Lifecycle
  public override func loadView() {
    setupView()
    setupButton()
  }
  
  private func setupView() {
    view = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
    view.backgroundColor = .white
  }
  
  private func setupButton() {
    button = UIButton()
    view.addSubview(button)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    button.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    button.heightAnchor.constraint(greaterThanOrEqualToConstant: 100).isActive = true
    button.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
    
    button.setTitle(text, for: .normal)
    button.titleLabel?.numberOfLines = 0
    button.titleLabel?.lineBreakMode = .byWordWrapping
    button.backgroundColor = buttonColor
    button.addTarget(self, action: #selector(nextButtonPressed(_:)), for: .touchUpInside)
  }
  
  @objc private func nextButtonPressed(_ sender: AnyObject) {
    delegate?.stepViewControllerDidPressNext(self)
  }
}

// MARK: - Constructors
extension StepViewController {
  
  public class func instantiate(delegate: StepViewControllerDelegate?,
                                buttonColor: UIColor,
                                text: String,
                                title: String) -> StepViewController {
    let viewController = StepViewController()
    viewController.delegate = delegate
    viewController.buttonColor = buttonColor
    viewController.text = text
    viewController.title = title
    return viewController
  }
}
