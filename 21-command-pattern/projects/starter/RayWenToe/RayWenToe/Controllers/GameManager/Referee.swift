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

// MARK: - Referee
public final class Referee {

  // MARK: - Instance Properties
  public let gameboard: Gameboard
  public let player1: Player
  public let player2: Player

  public private(set) lazy var winningCombinations: [[GameboardPosition]] = {
    var winningCombinations: [[GameboardPosition]] = []
    generateWinsByColumn(result: &winningCombinations)
    generateWinsByRow(result: &winningCombinations)
    generateWinLeftDiagonal(result: &winningCombinations)
    generateWinRightDiagonal(result: &winningCombinations)
    return winningCombinations
  }()

  private func generateWinsByColumn(result: inout [[GameboardPosition]]) {
    var array: [GameboardPosition] = []
    for column in 0 ..< gameboard.size.columns {
      for row in 0 ..< gameboard.size.rows {
        array.append(GameboardPosition(column: column, row: row))
      }
      result.append(array)
      array = []
    }
  }

  private func generateWinsByRow(result: inout [[GameboardPosition]]) {
    var array: [GameboardPosition] = []
    for row in 0 ..< gameboard.size.rows {    // 0 ..< 3
      for column in 0 ..< gameboard.size.columns {  // 0 ..< 3
        array.append(GameboardPosition(column: column, row: row))
      }
      result.append(array)
      array = []
    }
  }

  private func generateWinLeftDiagonal(result: inout [[GameboardPosition]]) {
    guard gameboard.size.columns == gameboard.size.rows else { return }
    var array: [GameboardPosition] = []
    for i in 0 ..< gameboard.size.columns {
      array.append(GameboardPosition(column: i, row: i))
    }
    result.append(array)
  }

  private func generateWinRightDiagonal(result: inout [[GameboardPosition]]) {
    guard gameboard.size.columns == gameboard.size.rows else { return }
    var array: [GameboardPosition] = []
    for i in 0 ..< gameboard.size.rows {
      array.append(GameboardPosition(column: i, row: gameboard.size.rows - 1 - i))
    }
    result.append(array)
  }

  // MARK: - Object Lifecycle
  public init(gameboard: Gameboard, player1: Player, player2: Player) {
    self.gameboard = gameboard
    self.player1 = player1
    self.player2 = player2
  }

  // MARK: - Actions
  public func determineWinner() -> Player {
    if doesPlayerHaveWinningCombination(player1) {
      return player1

    } else if doesPlayerHaveWinningCombination(player2) {
      return player2

    } else {
      return player1
    }
  }

  private func doesPlayerHaveWinningCombination(_ player: Player) -> Bool {
    for winningPositions in winningCombinations {
      if gameboard.contains(player: player, at: winningPositions) {
        return true
      }
    }
    return false
  }
}
