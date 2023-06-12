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

// MARK: - GameboardViewDelegate
@objc public protocol GameboardViewDelegate {

  func gameboardView(_ gameboardView: GameboardView,
                     didSelectPosition position: GameboardPosition)
}

// MARK: - GameboardView
@IBDesignable public class GameboardView: UIView {

  // MARK: - IBOutlets
  @IBOutlet public var delegate: GameboardViewDelegate?

  // MARK: - Configuration Properties
  @IBInspectable public var columns: Int {
    get { return boardSize.columns }
    set { boardSize = GameboardSize(columns: newValue, rows: boardSize.rows) }
  }
  @IBInspectable public var rows: Int {
    get { return boardSize.rows }
    set { boardSize = GameboardSize(columns: boardSize.columns, rows: newValue) }
  }
  @IBInspectable public var lineColor: UIColor = .black
  @IBInspectable public lazy var lineWidth: CGFloat = 7

  public var boardSize = GameboardSize(columns: 3, rows: 3) {
    didSet { setNeedsDisplay() }
  }

  // MARK: - Private Properties
  public private(set) var markViewForPosition: [GameboardPosition: MarkView] = [:]
  private let markViewSemaphore = DispatchSemaphore(value: 1)
  private let markViewQueue = DispatchQueue(label: "MarkViewQueue")

  // MARK: - Computed Properties
  private var calculatedColumnWidth: CGFloat {
    return 1/CGFloat(columns) * bounds.width
  }
  private var calculatedRowHeight: CGFloat {
    return 1/CGFloat(rows) * bounds.height
  }

  // MARK: - View Rendering
  public override func draw(_ rect: CGRect) {
    super.draw(rect)
    lineColor.setStroke()
    drawColumnLines(for: rect)
    drawRowLines(for: rect)
  }

  private func drawColumnLines(for rect: CGRect) {
    let columnWidth = self.calculatedColumnWidth
    for i in 1 ..< columns {
      let linePath = UIBezierPath()
      linePath.move(to: CGPoint(x: rect.minX + CGFloat(i) * columnWidth,
                                y: rect.minY))
      linePath.addLine(to: CGPoint(x: rect.minX + CGFloat(i) * columnWidth,
                                   y: rect.minY + rect.height))
      linePath.lineWidth = lineWidth
      linePath.stroke()
    }
  }

  private func drawRowLines(for rect: CGRect) {
    let rowHeight = self.calculatedRowHeight
    for i in 1 ..< rows {
      let linePath = UIBezierPath()
      linePath.move(to: CGPoint(x: rect.minX, y: rect.minY + CGFloat(i) * rowHeight))
      linePath.addLine(to: CGPoint(x: rect.minX + rect.width, y: rect.minY + CGFloat(i) * rowHeight))
      linePath.lineWidth = lineWidth
      linePath.stroke()
    }
  }

  public override func layoutSubviews() {
    super.layoutSubviews()
    for (position, markView) in markViewForPosition {
      updateFrame(for: markView, at: position)
    }
  }

  // MARK: - Touch Handling
  public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let touchLocation = touches.first?.location(in: self) else { return }
    let position = GameboardPosition(column: determineColumn(for: touchLocation),
                                     row: determineRow(for: touchLocation))
    delegate?.gameboardView(self, didSelectPosition: position)
  }

  private func determineColumn(for touchLocation: CGPoint) -> Int {
    let columnWidth = self.calculatedColumnWidth
    let lastColumn = columns - 1
    for i in (0 ..< lastColumn) {
      let xMin = CGFloat(i) * columnWidth
      let xMax = CGFloat(i + 1) * columnWidth
      if (xMin ..< xMax).contains(touchLocation.x) {
        return i
      }
    }
    return lastColumn
  }

  private func determineRow(for touchLocation: CGPoint) -> Int {
    let rowHeight = self.calculatedRowHeight
    let lastRow = rows - 1
    for i in (0 ..< lastRow) {
      let yMin = CGFloat(i) * rowHeight
      let yMax = CGFloat(i + 1) * rowHeight
      if (yMin ..< yMax).contains(touchLocation.y) {
        return i
      }
    }
    return lastRow
  }

  // MARK: - Managing MarkViews
  public func clear() {
    for (_, markView) in markViewForPosition {
      markView.removeFromSuperview()
    }
    markViewForPosition = [:]
  }

  public func placeMarkView(_ markView: MarkView, at position: GameboardPosition,
                            animated: Bool, completion: (() -> Void)? = nil) {
    markViewQueue.async { [weak self] in
      guard let self = self else { return }
      assert(self.boardSize.contains(position))
      self.markViewSemaphore.wait()

      DispatchQueue.main.async { [weak self] in
        guard let self = self else { return }
        self.removeMarkView(at: position, animated: animated) { [weak self] in
          guard let self = self else { return }
          self.addMarkView(markView, at: position, animated: animated) { [weak self] in
            guard let self = self else { return }
            self.markViewSemaphore.signal()
            completion?()
          }
        }
      }
    }
  }

  public func removeMarkView(at position: GameboardPosition,
                             animated: Bool,
                             completion: (() -> Void)? = nil) {
    guard let existingLayer = markViewForPosition[position] else {
      completion?()
      return
    }
    markViewForPosition[position] = nil

    guard animated else {
      existingLayer.removeFromSuperview()
      completion?()
      return
    }

    existingLayer.animateOut { [weak self] in
      guard let self = self else { return }
      existingLayer.removeFromSuperview()
      self.markViewForPosition[position] = nil
      completion?()
    }
  }

  private func addMarkView(_ markView: MarkView, at position: GameboardPosition, animated: Bool,
                           completion: @escaping () -> Void) {

    updateFrame(for: markView, at: position)

    markViewForPosition[position] = markView
    addSubview(markView)

    guard animated else {
      completion()
      return
    }
    markView.animateIn(completion: completion)
  }

  private func updateFrame(for markView: MarkView, at position: GameboardPosition) {
    let columnWidth = self.calculatedColumnWidth
    let rowHeight = self.calculatedRowHeight
    markView.frame = CGRect(x: CGFloat(position.column) * columnWidth,
                            y: CGFloat(position.row) * rowHeight,
                            width: columnWidth,
                            height: rowHeight).insetBy(dx: 0.5 * lineWidth,
                                                       dy: 0.5 * lineWidth)
  }
}
