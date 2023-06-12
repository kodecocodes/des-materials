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

public class AnimateState: DrawViewState {
  
  public override func animate() {
    guard let sublayers = drawView.layer.sublayers,
      sublayers.count > 0 else {
      transitionToState(
        matching: AcceptInputState.identifier)
      return
    }
    sublayers.forEach { $0.removeAllAnimations() }
    UIView.animate(withDuration: 0.3) {
      CATransaction.begin()
      CATransaction.setCompletionBlock { [weak self] in
        self?.transitionToState(
          matching: AcceptInputState.identifier)
      }
      self.setSublayersStrokeEnd(to: 0.0)
      self.animateStrokeEnds(of: sublayers, at: 0)
      CATransaction.commit()
    }
  }

  private func setSublayersStrokeEnd(to value: CGFloat) {
    drawView.layer.sublayers?.forEach {
      guard let shapeLayer = $0 as? CAShapeLayer else { return }
      shapeLayer.strokeEnd = 0.0
      let animation = CABasicAnimation(keyPath: "strokeEnd")
      animation.fromValue = value
      animation.toValue = value
      animation.fillMode =  .forwards
      shapeLayer.add(animation, forKey: nil)
    }
  }

  private func animateStrokeEnds(of layers: [CALayer], at index: Int) {
    guard index < layers.count else { return }
    let currentLayer = layers[index]
    CATransaction.begin()
    CATransaction.setCompletionBlock { [weak self] in
      currentLayer.removeAllAnimations()
      self?.animateStrokeEnds(of: layers, at: index + 1)
    }
    if let shapeLayer = currentLayer as? CAShapeLayer {
      shapeLayer.strokeEnd = 1.0
      let animation = CABasicAnimation(keyPath: "strokeEnd")
      animation.duration = 1.0
      animation.fillMode =  .forwards
      animation.fromValue = 0.0
      animation.toValue = 1.0
      shapeLayer.add(animation, forKey: nil)
    }
    CATransaction.commit()
  }
}
