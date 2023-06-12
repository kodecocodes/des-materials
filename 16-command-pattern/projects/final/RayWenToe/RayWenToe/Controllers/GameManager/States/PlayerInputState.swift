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

public class PlayerInputState: GameState {

  // MARK: - Instance Properties
  public let actionTitle: String
  public let player: Player

  // MARK: - Object Lifecycle
  public init(gameMode: GameManager, player: Player, actionTitle: String) {
    self.actionTitle = actionTitle
    self.player = player
    super.init(gameManager: gameMode)
  }

  // MARK: - Actions
  public override func begin() {
    gameplayView.actionButton.setTitle(actionTitle, for: .normal)
    gameplayView.gameboardView.clear()
    updatePlayerLabel()
    updateMoveCountLabel()
  }
  
  public override func addMove(at position: GameboardPosition) {
    let moveCount = movesForPlayer[player]!.count
    guard moveCount < turnsPerPlayer else { return }
    displayMarkView(at: position, turnNumber: moveCount + 1)
    enqueueMoveCommand(at: position)
    updateMoveCountLabel()
  }

  private func enqueueMoveCommand(at position: GameboardPosition) {
    let newMove = MoveCommand(gameboard: gameboard,
                              gameboardView: gameboardView,
                              player: player,
                              position: position)

    movesForPlayer[player]!.append(newMove)
  }

  private func displayMarkView(at position: GameboardPosition, turnNumber: Int) {
    guard let markView = gameplayView.gameboardView.markViewForPosition[position] else {
      let markView = player.markViewPrototype.copy() as MarkView
      markView.turnNumbers = [turnNumber]
      gameplayView.gameboardView.placeMarkView(markView, at: position, animated: false)
      return
    }
    markView.turnNumbers.append(turnNumber)
  }

  private func updatePlayerLabel() {
    gameplayView.playerLabel.text = player.turnMessage
  }

  private func updateMoveCountLabel() {
    let turnsRemaining = turnsPerPlayer - movesForPlayer[player]!.count
    gameplayView.moveCountLabel.text =
      "\(turnsRemaining) Moves Left"
  }

  public override func handleActionPressed() {
    guard movesForPlayer[player]!.count == turnsPerPlayer
      else { return }
    gameManager.transitionToNextState()
  }

  public override func handleUndoPressed() {
    var moves = movesForPlayer[player]!
    guard let position = moves.popLast()?.position else { return }

    movesForPlayer[player] = moves
    updateMoveCountLabel()

    let markView = gameboardView.markViewForPosition[position]!
    _ = markView.turnNumbers.popLast()

    guard markView.turnNumbers.count == 0 else { return }
    gameboardView.removeMarkView(at: position, animated: false)
  }
}
