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

public class PlayGameState: GameState {

  // MARK: - Instance Properties
  public let player1: Player
  public let player2: Player

  // MARK: - Object Lifecycle
  public init(gameMode: GameManager, player1: Player, player2: Player) {
    self.player1 = player1
    self.player2 = player2
    super.init(gameManager: gameMode)
  }

  // MARK: - Actions
  public override func begin() {
    gameplayView.isUserInteractionEnabled = false
    gameplayView.playerLabel.text = nil
    gameplayView.moveCountLabel.text = nil
    gameplayView.gameboardView.clear()

    let gameMoves = combinePlayerMoves()
    performMove(at: 0, with: gameMoves)
  }
  
  private func combinePlayerMoves() -> [MoveCommand] {
    var result: [MoveCommand] = []
    let player1Moves = movesForPlayer[player1]!
    let player2Moves = movesForPlayer[player2]!
    assert(player1Moves.count == player2Moves.count)
    for i in 0 ..< player1Moves.count {
      result.append(player1Moves[i])
      result.append(player2Moves[i])
    }
    return result
  }
  
  private func performMove(at index: Int,
                           with moves: [MoveCommand]) {
    guard index < moves.count else {
      displayWinner()
      return
    }
    let move = moves[index]
    move.execute(completion: { [weak self] in
      self?.performMove(at: index + 1, with: moves)
    })
  }

  private func displayWinner() {
    gameplayView.actionButton.setTitle("New Game", for: .normal)
    let winner = gameManager.referee.determineWinner()
    gameplayView.playerLabel.text = winner.winMessage
    gameplayView.isUserInteractionEnabled = true
  }

  public override func handleActionPressed() {
    gameManager.newGame()
  }
}
