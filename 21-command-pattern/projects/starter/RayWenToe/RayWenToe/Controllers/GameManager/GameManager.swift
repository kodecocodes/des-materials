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

public class GameManager {

  // MARK: - Instance Properties
  public weak var gameplayView: GameplayView! {
    didSet { gameboard = Gameboard(size: gameplayView.gameboardView.boardSize) }
  }
  public let player1: Player
  public let player2: Player
  public private(set) var gameboard: Gameboard!

  private var currentState: GameState {
    return states[currentStateIndex]
  }
  private var currentStateIndex = 0
  private var states: [GameState]!

  internal private(set) lazy var referee = Referee(gameboard: gameboard, player1: player1, player2: player2)

  internal var turnsPerPlayer: Int {
    return Int(ceil(0.5 * Double(gameboard.size.columns * gameboard.size.rows)))
  }

  // MARK: - Object Lifecycle
  public class func onePlayerMode() -> GameManager {
    let player1 = Player(markView: XView(), turnMessage: "Your Turn", winMessage: "You Win!")
    let player2 = Player(markView: OView(), turnMessage: "Computer's Turn", winMessage: "You Lose :[")
    let gameMode = GameManager(player1: player1, player2: player2)

    let playerInputState = PlayerInputState(gameMode: gameMode, player: player1, actionTitle: "Play")
    let computerInputState = ComputerInputState(gameMode: gameMode, player: player2)
    let playGameState = PlayGameState(gameMode: gameMode, player1: player1, player2: player2)
    gameMode.states = [playerInputState, computerInputState, playGameState]

    return gameMode
  }

  public class func twoPlayerMode() -> GameManager {
    let player1 = Player(markView: XView(), turnMessage: "X's turn", winMessage: "X Wins!")
    let player2 = Player(markView: OView(), turnMessage: "O's Turn", winMessage: "O Wins!")
    let gameMode = GameManager(player1: player1, player2: player2)

    let player1InputState = PlayerInputState(gameMode: gameMode, player: player1, actionTitle: "Ready")
    let player2InputState = PlayerInputState(gameMode: gameMode, player: player2, actionTitle: "Play")
    let playGameState = PlayGameState(gameMode: gameMode, player1: player1, player2: player2)
    gameMode.states = [player1InputState, player2InputState, playGameState]

    return gameMode
  }

  private init(player1: Player, player2: Player) {
    self.player1 = player1
    self.player2 = player2
  }

  // MARK: - Game Play Methods
  public func newGame() {
    gameboard.clear()
    gameplayView.gameboardView.clear()

    // TODO: - Reset movesForPlayers

    currentStateIndex = 0
    currentState.begin()
  }

  public func addMove(at position: GameboardPosition) {
    currentState.addMove(at: position)
  }

  public func handleActionPressed() {
    currentState.handleActionPressed()
  }

  public func handleUndoPressed() {
    currentState.handleUndoPressed()
  }

  internal func transitionToNextState() {
    if currentStateIndex + 1 < states.count {
      currentStateIndex += 1
    } else {
      currentStateIndex = 0
    }
    currentState.begin()
  }
}
