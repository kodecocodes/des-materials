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

import Foundation

public final class Gameboard: NSObject {

  // MARK: - Instance Properties
  public private(set) lazy var positions: [[Player?]] = generateBoardPositions()

  private func generateBoardPositions() -> [[Player?]] {
    var positions: [[Player?]] = []
    for _ in 0 ..< size.columns {
      let rows = Array<Player?>(repeating: nil, count: size.rows)
      positions.append(rows)
    }
    return positions
  }

  public let size: GameboardSize

  // MARK: - Object Lifecycle
  public init(size: GameboardSize = GameboardSize(columns: 3, rows: 3)) {
    self.size = size
  }

  // MARK: - Instance Methods
  public func clear() {
    self.positions = generateBoardPositions()
  }

  public func setPlayer(_ player: Player, at position: GameboardPosition) {
    positions[position.column][position.row] = player
  }

  public func contains(player: Player, at positions: [GameboardPosition]) -> Bool {
    for position in positions {
      guard contains(player: player, at: position) else {
        return false
      }
    }
    return true
  }

  public func contains(player: Player, at position: GameboardPosition) -> Bool {
    let (column, row) = (position.column, position.row)
    return positions[column][row] === player
  }
}
