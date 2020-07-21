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

import GameplayKit.GKRandomSource

public class RandomQuestionStrategy: QuestionStrategy {
  // MARK: - Properties
  public var correctCount: Int = 0
  public var incorrectCount: Int = 0
  private let questionGroup: QuestionGroup
  private var questionIndex = 0
  private let questions: [Question]
  
  // MARK: - Object Lifecycle
  public init(questionGroup: QuestionGroup) {
    self.questionGroup = questionGroup
    
    // 2
    let randomSource = GKRandomSource.sharedRandom()
    self.questions =
      randomSource.arrayByShufflingObjects(
        in: questionGroup.questions) as! [Question]
  }
  
  // MARK: - QuestionStrategy
  public var title: String {
    return questionGroup.title
  }
  
  public func currentQuestion() -> Question {
    return questions[questionIndex]
  }
  
  public func advanceToNextQuestion() -> Bool {
    guard questionIndex + 1 < questions.count else {
      return false
    }
    questionIndex += 1
    return true
  }
  
  public func markQuestionCorrect(_ question: Question) {
    correctCount += 1
  }
  
  public func markQuestionIncorrect(_ question: Question) {
    incorrectCount += 1
  }
  
  public func questionIndexTitle() -> String {
    return "\(questionIndex + 1)/\(questions.count)"
  }
}
