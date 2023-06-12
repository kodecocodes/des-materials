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

// MARK: - Test Module
@testable import RayWenToe

// MARK: - Collaborators

// MARK: - Test Support
import XCTest

class RefereeTests: XCTestCase {

  // MARK: - Instance Variables
  var sut: Referee!

  let gameboard = Gameboard(size: GameboardSize(columns: 3, rows: 3))
  let player1 = Player(markView: XView(), turnMessage: "", winMessage: "")
  let player2 = Player(markView: XView(), turnMessage: "", winMessage: "")

  // MARK: - Test Lifecycle
  override func setUp() {
    super.setUp()
    sut = Referee(gameboard: gameboard, player1: player1, player2: player2)
  }

  override func tearDown() {
    sut = nil
    super.tearDown()
  }

  // MARK: - Given
  private func givenWin(byColumn column: Int, player: Player) {
    gameboard.setPlayer(player, at: GameboardPosition(column: column, row: 0))
    gameboard.setPlayer(player, at: GameboardPosition(column: column, row: 1))
    gameboard.setPlayer(player, at: GameboardPosition(column: column, row: 2))
  }

  private func givenWin(byRow row: Int, player: Player) {
    gameboard.setPlayer(player, at: GameboardPosition(column: 0, row: row))
    gameboard.setPlayer(player, at: GameboardPosition(column: 1, row: row))
    gameboard.setPlayer(player, at: GameboardPosition(column: 2, row: row))
  }

  private func givenWinByLeftDiagonal(player: Player) {
    gameboard.setPlayer(player, at: GameboardPosition(column: 0, row: 0))
    gameboard.setPlayer(player, at: GameboardPosition(column: 1, row: 1))
    gameboard.setPlayer(player, at: GameboardPosition(column: 2, row: 2))
  }

  private func givenWinByRightDiagonal(player: Player) {
    gameboard.setPlayer(player, at: GameboardPosition(column: 0, row: 2))
    gameboard.setPlayer(player, at: GameboardPosition(column: 1, row: 1))
    gameboard.setPlayer(player, at: GameboardPosition(column: 2, row: 0))
  }

  // MARK: - Win by Column - Tests
  func test_determineWinner_givenPlayer1WinsByColumn0_returnsPlayer1() {
    givenWin(byColumn: 0, player: player1)
    XCTAssertEqual(sut.determineWinner(), player1)
  }

  func test_determineWinner_givenPlayer1WinsByColumn1_returnsPlayer1() {
    givenWin(byColumn: 1, player: player1)
    XCTAssertEqual(sut.determineWinner(), player1)
  }

  func test_determineWinner_givenPlayer1WinsByColumn2_returnsPlayer1() {
    givenWin(byColumn: 2, player: player1)
    XCTAssertEqual(sut.determineWinner(), player1)
  }

  func test_determineWinner_givenPlayer2WinsByColumn0_returnsPlayer1() {
    givenWin(byColumn: 0, player: player2)
    XCTAssertEqual(sut.determineWinner(), player2)
  }

  func test_determineWinner_givenPlayer2WinsByColumn1_returnsPlayer1() {
    givenWin(byColumn: 1, player: player2)
    XCTAssertEqual(sut.determineWinner(), player2)
  }

  func test_determineWinner_givenPlayer2WinsByColumn2_returnsPlayer1() {
    givenWin(byColumn: 2, player: player2)
    XCTAssertEqual(sut.determineWinner(), player2)
  }

  // MARK: - Win by Row - Tests
  func test_determineWinner_givenPlayer1WinsByRow0_returnsPlayer1() {
    givenWin(byRow: 0, player: player1)
    XCTAssertEqual(sut.determineWinner(), player1)
  }

  func test_determineWinner_givenPlayer1WinsByRow1_returnsPlayer1() {
    givenWin(byRow: 0, player: player1)
    XCTAssertEqual(sut.determineWinner(), player1)
  }

  func test_determineWinner_givenPlayer1WinsByRow2_returnsPlayer1() {
    givenWin(byRow: 0, player: player1)
    XCTAssertEqual(sut.determineWinner(), player1)
  }

  func test_determineWinner_givenPlayer2WinsByRow0_returnsPlayer1() {
    givenWin(byRow: 0, player: player2)
    XCTAssertEqual(sut.determineWinner(), player2)
  }

  func test_determineWinner_givenPlayer2WinsByRow1_returnsPlayer1() {
    givenWin(byRow: 0, player: player2)
    XCTAssertEqual(sut.determineWinner(), player2)
  }

  func test_determineWinner_givenPlayer2WinsByRow2_returnsPlayer1() {
    givenWin(byRow: 0, player: player2)
    XCTAssertEqual(sut.determineWinner(), player2)
  }

  // MARK: - Win by Left Diagonal - Tests
  func test_determineWinner_givenPlayer1WinsByLeftDiagonal_returnsPlayer1() {
    givenWinByLeftDiagonal(player: player1)
    XCTAssertEqual(sut.determineWinner(), player1)
  }

  func test_determineWinner_givenPlayer2WinsByLeftDiagonal_returnsPlayer2() {
    givenWinByLeftDiagonal(player: player2)
    XCTAssertEqual(sut.determineWinner(), player2)
  }

  // MARK: - Win by Right Diagonal - Tests
  func test_determineWinner_givenPlayer1WinsByRightDiagonal_returnsPlayer1() {
    givenWinByRightDiagonal(player: player1)
    XCTAssertEqual(sut.determineWinner(), player1)
  }

  func test_determineWinner_givenPlayer2WinsByRightDiagonal_returnsPlayer2() {
    givenWinByRightDiagonal(player: player2)
    XCTAssertEqual(sut.determineWinner(), player2)
  }

  // MARK: - Two Winners - Test
  func test_determineWinner_givenBothPlayer1AndPlayer2WinByColumn_returnsPlayer1() {
    // given
    givenWin(byColumn: 0, player: player1)
    givenWin(byColumn: 2, player: player2)
    let expected = player1

    // when
    let actual = sut.determineWinner()

    // then
    XCTAssertEqual(actual, expected)
  }

  func test_determineWinner_givenBothPlayer1AndPlayer2WinByRow_returnsPlayer1() {
    // given
    givenWin(byRow: 0, player: player1)
    givenWin(byRow: 2, player: player2)
    let expected = player1

    // when
    let actual = sut.determineWinner()

    // then
    XCTAssertEqual(actual, expected)
  }

  // MARK: - No Winners - Tests
  func test_determineWinner_givenNeitherPlayerWins_returnsPlayer1() {
    XCTAssertEqual(sut.determineWinner(), player1)
  }
}
