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

@IBDesignable public class MarkView: UIView, Copying {

  // MARK: - Properties
  public override var frame: CGRect {
    didSet {
      setNeedsLayout()
      layoutIfNeeded()
    }
  }
  public override var bounds: CGRect {
    didSet {
      setNeedsLayout()
      layoutIfNeeded()
    }
  }
  @IBInspectable public var lineColor: UIColor = .black
  @IBInspectable public var lineWidth: CGFloat = 7
  @IBInspectable public var textColor: UIColor = .red {
    didSet { label.textColor = textColor }
  }

  public var turnNumbers: [Int] = [] {
    didSet {
      label.text = turnNumbers.map { String($0) }.joined(separator: ",")
    }
  }

  internal private(set) lazy var shapeLayer: CAShapeLayer = { [unowned self] in
    let shapeLayer = CAShapeLayer()
    shapeLayer.fillColor = nil
    shapeLayer.lineWidth = lineWidth
    shapeLayer.strokeColor = lineColor.cgColor
    self.layer.addSublayer(shapeLayer)
    return shapeLayer
  }()

  internal private(set) lazy var label: UILabel = { [unowned self] in

    let label = UILabel(frame: CGRect(x: 0, y: 0, width: bounds.width, height: 0.1 * bounds.height))
    label.textColor = textColor
    label.textAlignment = .right
    addSubview(label)

    label.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint(item: label, attribute: .top, relatedBy: .equal,
                       toItem: self, attribute: .top, multiplier: 1, constant: 4).isActive = true
    NSLayoutConstraint(item: label, attribute: .height, relatedBy: .equal,
                       toItem: self, attribute: .height, multiplier: 0.1, constant: 0).isActive = true
    NSLayoutConstraint(item: label, attribute: .leading, relatedBy: .equal,
                       toItem: self, attribute: .leading, multiplier: 1, constant: 0).isActive = true
    NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal,
                       toItem: label, attribute: .trailing, multiplier: 1, constant: 4).isActive = true

    return label
  }()

  // MARK: - Object Lifecycle
  public init() {
    super.init(frame: CGRect(origin: .zero,
                             size: CGSize(width: 90, height: 90)))
  }

  public required init(_ prototype: MarkView) {
    super.init(frame: prototype.frame)
    lineColor = prototype.lineColor
    lineWidth = prototype.lineWidth
    turnNumbers = prototype.turnNumbers
    textColor = prototype.textColor
  }

  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  public final override func layoutSubviews() {
    super.layoutSubviews()
    updateLabel()
    updateShapeLayer()
  }

  private final func updateLabel() {
    let size = 0.1 * bounds.height
    label.font = UIFont.systemFont(ofSize: size, weight: .thin)
  }

  internal func updateShapeLayer() {
    // meant for subclasses to override
  }

  // MARK: - Instance Methods
  public func animateIn(duration: TimeInterval = 1.0,
                        completion: @escaping () -> Void) {
    CATransaction.begin()
    CATransaction.setCompletionBlock(completion)
    let animation = CABasicAnimation(keyPath: "strokeEnd")
    animation.duration = duration
    animation.fromValue = 0.0
    animation.toValue = 1.0
    shapeLayer.add(animation, forKey: nil)
    CATransaction.commit()
  }

  public func animateOut(duration: TimeInterval = 1.0,
                         completion: @escaping () -> Void) {

    CATransaction.begin()
    CATransaction.setCompletionBlock(completion)
    let animation = CABasicAnimation(keyPath: "opacity")
    animation.duration = duration
    animation.fromValue = 1.0
    animation.toValue = 0.0
    shapeLayer.add(animation, forKey: nil)
    CATransaction.commit()
  }
}
