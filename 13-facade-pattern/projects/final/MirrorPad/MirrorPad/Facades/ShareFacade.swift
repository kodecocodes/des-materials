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

public class ShareFacade {

  // MARK: - Instance Properties
  public unowned var entireDrawing: UIView
  public unowned var inputDrawing: UIView
  public unowned var parentViewController: UIViewController

  private var imageRenderer = ImageRenderer()

  // MARK: - Object Lifecycle
  public init(entireDrawing: UIView,
              inputDrawing: UIView,
              parentViewController: UIViewController) {
    self.entireDrawing = entireDrawing
    self.inputDrawing = inputDrawing
    self.parentViewController = parentViewController
  }

  // MARK: - Facade Methods
  public func presentShareController() {
    let selectionViewController =
      DrawingSelectionViewController.createInstance(
        entireDrawing: entireDrawing,
        inputDrawing: inputDrawing,
        delegate: self)

    parentViewController.present(selectionViewController,
                                 animated: true)
  }
}

// MARK: - DrawingSelectionViewControllerDelegate
extension ShareFacade: DrawingSelectionViewControllerDelegate {

  public func drawingSelectionViewControllerDidCancel(
    _ viewController: DrawingSelectionViewController) {
    parentViewController.dismiss(animated: true)
  }

  public func drawingSelectionViewController(
    _ viewController: DrawingSelectionViewController,
    didSelectView view: UIView) {

    parentViewController.dismiss(animated: false)
    let image = imageRenderer.convertViewToImage(view)

    let activityViewController = UIActivityViewController(
      activityItems: [image],
      applicationActivities: nil)
    parentViewController.present(activityViewController,
                                 animated: true)
  }
}
