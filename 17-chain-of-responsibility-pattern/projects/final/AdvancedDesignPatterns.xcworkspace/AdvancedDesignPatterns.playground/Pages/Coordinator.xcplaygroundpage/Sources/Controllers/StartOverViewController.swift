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

// MARK: - StartOverViewControllerDelegate
public protocol StartOverViewControllerDelegate: class {
  func startOverViewControllerDidPressStartOver(_ controller: StartOverViewController)
}

// MARK: - StartOverViewController
public class StartOverViewController: UIViewController {
  
  // MARK: - Instance Properties
  public var delegate: StartOverViewControllerDelegate?
  
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
    button.heightAnchor.constraint(equalToConstant: 100).isActive = true
    button.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
    
    button.setTitle("START OVER", for: .normal)
    button.backgroundColor = .black
    button.addTarget(self, action: #selector(startButtonPressed(_:)), for: .touchUpInside)
  }
  
  @objc private func startButtonPressed(_ sender: AnyObject) {
    delegate?.startOverViewControllerDidPressStartOver(self)
  }
}

// MARK: - Constructors
extension StartOverViewController {
  
  public class func instantiate(delegate: StartOverViewControllerDelegate?) -> StartOverViewController {
    let viewController = StartOverViewController()
    viewController.delegate = delegate
    viewController.title = "Start Over?"
    return viewController
  }
}
