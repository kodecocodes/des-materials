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

@objc public protocol DrawViewDelegate: class {
  func drawView(_ source: DrawView, didAddLine line: LineShape)
  func drawView(_ source: DrawView, didAddPoint point: CGPoint)
}

public class DrawView: UIView {

  // MARK: - Instance Properties
  public var lineColor: UIColor = .black
  public var lineWidth: CGFloat = 5.0
  public var lines: [LineShape] = []

  @IBInspectable public var scaleX: CGFloat = 1 {
    didSet { applyTransform() }
  }
  @IBInspectable public var scaleY: CGFloat = 1 {
    didSet { applyTransform() }
  }
  private func applyTransform() {
    layer.sublayerTransform = CATransform3DMakeScale(scaleX, scaleY, 1)
  }
  
  public lazy var currentState = states[AcceptInputState.identifier]!

  public lazy var states = [
    AcceptInputState.identifier: AcceptInputState(drawView: self),
    AnimateState.identifier: AnimateState(drawView: self),
    ClearState.identifier: ClearState(drawView: self),
    CopyState.identifier: CopyState(drawView: self)
  ]


  // MARK: - UIResponder
  public override func touchesBegan(_ touches: Set<UITouch>,
                                    with event: UIEvent?) {
    currentState.touchesBegan(touches, with: event)
  }

  public override func touchesMoved(_ touches: Set<UITouch>,
                                    with event: UIEvent?) {
    currentState.touchesMoved(touches, with: event)
  }

  // MARK: - Actions
  public func animate() {
    currentState.animate()
  }
  
  public func clear() {
    currentState.clear()
  }
  
  public func copyLines(from source: DrawView) {
    currentState.copyLines(from: source)
  }
  
  // MARK: - Delegate Management
  public let multicastDelegate =
    MulticastDelegate<DrawViewDelegate>()

  public func addDelegate(_ delegate: DrawViewDelegate) {
    multicastDelegate.addDelegate(delegate)
  }

  public func removeDelegate(_ delegate: DrawViewDelegate) {
    multicastDelegate.removeDelegate(delegate)
  }
}

// MARK: - DrawViewDelegate
extension DrawView: DrawViewDelegate {

  public func drawView(_ source: DrawView,
                       didAddLine line: LineShape) {
    currentState.drawView(source, didAddLine: line)
  }

  public func drawView(_ source: DrawView,
                       didAddPoint point: CGPoint) {
    currentState.drawView(source, didAddPoint: point)
  }
}
