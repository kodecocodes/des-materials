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

import Combine
import Foundation

public class QuestionGroup: Codable {
  
  public class Score: Codable {
    public var correctCount: Int = 0 {
      didSet { updateRunningPercentage() }
    }
    public var incorrectCount: Int = 0 {
      didSet { updateRunningPercentage() }
    }
    @Published public var runningPercentage: Double = 0
    
    public init() { }
        
    private enum CodingKeys: String, CodingKey {
      case correctCount
      case incorrectCount
    }

    public required init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      self.correctCount = try container.decode(Int.self, forKey: .correctCount)
      self.incorrectCount = try container.decode(Int.self, forKey: .incorrectCount)
      updateRunningPercentage()
    }

    private func updateRunningPercentage() {
      let totalCount = correctCount + incorrectCount
      guard totalCount > 0 else {
        runningPercentage = 0
        return
      }
      runningPercentage = Double(correctCount) / Double(totalCount)
    }
    
    public func reset() {
      correctCount = 0
      incorrectCount = 0
    }
  }
  
  public let questions: [Question]
  public private(set) var score: Score
  public let title: String
    
  public init(questions: [Question],
              score: Score = Score(),
              title: String) {
    self.questions = questions
    self.score = score
    self.title = title
  }
}
