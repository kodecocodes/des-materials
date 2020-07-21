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

public class AcceptInputState: DrawViewState {
  
  public override func animate() {
    let animateState = transitionToState(
      matching: AnimateState.identifier)
    animateState.animate()
  }

  public override func clear() {
    let clearState = transitionToState(
      matching: ClearState.identifier)
    clearState.clear()
  }

  public override func copyLines(from source: DrawView) {
    let copyState = transitionToState(
      matching: CopyState.identifier)
    copyState.copyLines(from: source)
  }

  public override func touchesBegan(_ touches: Set<UITouch>,
                                    with event: UIEvent?) {
    guard let point = touches.first?.location(in: drawView)
      else { return }
    let line = LineShape(color: drawView.lineColor,
                         width: drawView.lineWidth,
                         startPoint: point)
    addLine(line)
    drawView.multicastDelegate.invokeDelegates {
      $0.drawView(drawView, didAddLine: line)
    }
  }

  private func addLine(_ line: LineShape) {
    drawView.lines.append(line)
    drawView.layer.addSublayer(line)
  }
  
  public override func touchesMoved(_ touches: Set<UITouch>,
                                    with event: UIEvent?) {
    guard let point = touches.first?.location(in: drawView)
      else { return }
    addPoint(point)
    drawView.multicastDelegate.invokeDelegates {
      $0.drawView(drawView, didAddPoint: point)
    }
  }

  private func addPoint(_ point: CGPoint) {
    drawView.lines.last?.addPoint(point)
  }
}

// MARK: - DrawViewDelegate
extension AcceptInputState {

  public override func drawView(_ source: DrawView,
                                didAddLine line: LineShape) {
    let newLine = line.copy() as LineShape
    addLine(newLine)
  }

  public override func drawView(_ source: DrawView,
                                didAddPoint point: CGPoint) {
    addPoint(point)
  }
}
