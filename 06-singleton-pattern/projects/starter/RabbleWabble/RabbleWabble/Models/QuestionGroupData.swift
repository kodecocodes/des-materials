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

// MARK: - Data
extension QuestionGroup {

  public static func allGroups() -> [QuestionGroup] {
    return [hiragana(), katakana(), basicPhrases(), numbers()]
  }

  public static func hiragana() -> QuestionGroup {
    let questions = [
      Question(answer: "a", hint: nil, prompt: "あ"),
      Question(answer: "i", hint: nil, prompt: "い"),
      Question(answer: "u", hint: nil, prompt: "う"),
      Question(answer: "e", hint: nil, prompt: "え"),
      Question(answer: "o", hint: nil, prompt: "お"),
      Question(answer: "ka", hint: nil, prompt: "か"),
      Question(answer: "ki", hint: nil, prompt: "き"),
      Question(answer: "ku", hint: nil, prompt: "く"),
      Question(answer: "ke", hint: nil, prompt: "け"),
      Question(answer: "ko", hint: nil, prompt: "こ"),
      Question(answer: "sa", hint: nil, prompt: "さ"),
      Question(answer: "shi", hint: nil, prompt: "し"),
      Question(answer: "su", hint: nil, prompt: "す"),
      Question(answer: "se", hint: nil, prompt: "せ"),
      Question(answer: "so", hint: nil, prompt: "そ"),
      Question(answer: "ta", hint: nil, prompt: "た"),
      Question(answer: "chi", hint: nil, prompt: "ち"),
      Question(answer: "tsu", hint: nil, prompt: "つ"),
      Question(answer: "te", hint: nil, prompt: "て"),
      Question(answer: "to", hint: nil, prompt: "と"),
      Question(answer: "na", hint: nil, prompt: "な"),
      Question(answer: "ni", hint: nil, prompt: "に"),
      Question(answer: "nu", hint: nil, prompt: "ぬ"),
      Question(answer: "ne", hint: nil, prompt: "ね"),
      Question(answer: "no", hint: nil, prompt: "の"),
      Question(answer: "ha", hint: nil, prompt: "は"),
      Question(answer: "hi", hint: nil, prompt: "ひ"),
      Question(answer: "fu", hint: nil, prompt: "ふ"),
      Question(answer: "he", hint: nil, prompt: "へ"),
      Question(answer: "ho", hint: nil, prompt: "ほ"),
      Question(answer: "ma", hint: nil, prompt: "ま"),
      Question(answer: "mi", hint: nil, prompt: "み"),
      Question(answer: "mu", hint: nil, prompt: "む"),
      Question(answer: "me", hint: nil, prompt: "め"),
      Question(answer: "mo", hint: nil, prompt: "も"),
      Question(answer: "ya", hint: nil, prompt: "や"),
      Question(answer: "yu", hint: nil, prompt: "ゆ"),
      Question(answer: "yo", hint: nil, prompt: "よ"),
      Question(answer: "ra", hint: nil, prompt: "ら"),
      Question(answer: "ri", hint: nil, prompt: "り"),
      Question(answer: "ru", hint: nil, prompt: "る"),
      Question(answer: "re", hint: nil, prompt: "れ"),
      Question(answer: "ro", hint: nil, prompt: "ろ"),
      Question(answer: "wa", hint: nil, prompt: "わ"),
      Question(answer: "wo", hint: nil, prompt: "を"),
      Question(answer: "n", hint: nil, prompt: "ん")
    ]
    return QuestionGroup(questions: questions, title: "Hiragana")
  }

  public static func katakana() -> QuestionGroup {
    let questions = [
      Question(answer: "a", hint: nil, prompt: "ア"),
      Question(answer: "i", hint: nil, prompt: "イ"),
      Question(answer: "u", hint: nil, prompt: "ウ"),
      Question(answer: "e", hint: nil, prompt: "エ"),
      Question(answer: "o", hint: nil, prompt: "オ"),
      Question(answer: "ka", hint: nil, prompt: "カ"),
      Question(answer: "ki", hint: nil, prompt: "キ"),
      Question(answer: "ku", hint: nil, prompt: "ク"),
      Question(answer: "ke", hint: nil, prompt: "ケ"),
      Question(answer: "ko", hint: nil, prompt: "コ"),
      Question(answer: "sa", hint: nil, prompt: "サ"),
      Question(answer: "shi", hint: nil, prompt: "シ"),
      Question(answer: "su", hint: nil, prompt: "ス"),
      Question(answer: "se", hint: nil, prompt: "セ"),
      Question(answer: "so", hint: nil, prompt: "ソ"),
      Question(answer: "ta", hint: nil, prompt: "タ"),
      Question(answer: "chi", hint: nil, prompt: "チ"),
      Question(answer: "tsu", hint: nil, prompt: "ツ"),
      Question(answer: "te", hint: nil, prompt: "テ"),
      Question(answer: "to", hint: nil, prompt: "ト"),
      Question(answer: "na", hint: nil, prompt: "ナ"),
      Question(answer: "ni", hint: nil, prompt: "ニ"),
      Question(answer: "nu", hint: nil, prompt: "ヌ"),
      Question(answer: "ne", hint: nil, prompt: "ネ"),
      Question(answer: "no", hint: nil, prompt: "ノ"),
      Question(answer: "ha", hint: nil, prompt: "ハ"),
      Question(answer: "hi", hint: nil, prompt: "ヒ"),
      Question(answer: "fu", hint: nil, prompt: "フ"),
      Question(answer: "he", hint: nil, prompt: "ヘ"),
      Question(answer: "ho", hint: nil, prompt: "ホ"),
      Question(answer: "ma", hint: nil, prompt: "マ"),
      Question(answer: "mi", hint: nil, prompt: "ミ"),
      Question(answer: "mu", hint: nil, prompt: "ム"),
      Question(answer: "me", hint: nil, prompt: "メ"),
      Question(answer: "mo", hint: nil, prompt: "モ"),
      Question(answer: "ya", hint: nil, prompt: "ヤ"),
      Question(answer: "yu", hint: nil, prompt: "ユ"),
      Question(answer: "yo", hint: nil, prompt: "ヨ"),
      Question(answer: "ra", hint: nil, prompt: "ラ"),
      Question(answer: "ri", hint: nil, prompt: "リ"),
      Question(answer: "ru", hint: nil, prompt: "ル"),
      Question(answer: "re", hint: nil, prompt: "レ"),
      Question(answer: "ro", hint: nil, prompt: "ロ"),
      Question(answer: "wa", hint: nil, prompt: "ワ"),
      Question(answer: "wo", hint: nil, prompt: "ヲ"),
      Question(answer: "n", hint: nil, prompt: "ン")
    ]
    return QuestionGroup(questions: questions, title: "Katakana")
  }

  public static func basicPhrases() -> QuestionGroup {
    let questions = [
      Question(answer: "Hello,\nGood Morning", hint: "ohayou", prompt: "おはよう"),
      Question(answer: "Hello,\nGood Afternoon", hint: "konnichiwa", prompt: "こんにちは"),
      Question(answer: "Hello,\nGood Evening", hint: "konnbanwa", prompt: "こんばんは"),
      Question(answer: "Thanks", hint: "arigatou", prompt: "ありがとう"),
      Question(answer: "You're Welcome", hint: "douitashimashite", prompt: "どういたしまして"),
      Question(answer: "~ is.", hint: "~ Desu", prompt: "〜です"),
      Question(answer: "Please give me ~.", hint: "~　wo kudasai", prompt: "〜をください")
    ]
    return QuestionGroup(questions: questions, title: "Basic Phrases")
  }

  public static func numbers() -> QuestionGroup {
    let questions = [
      Question(answer: "one", hint: "ichi", prompt: "一"),
      Question(answer: "two", hint: "ni", prompt: "二"),
      Question(answer: "three", hint: "san", prompt: "三"),
      Question(answer: "four", hint: "shi", prompt: "四"),
      Question(answer: "five", hint: "go", prompt: "五"),
      Question(answer: "six", hint: "roku", prompt: "六"),
      Question(answer: "seven", hint: "nana", prompt: "七"),
      Question(answer: "eight", hint: "hachi", prompt: "八"),
      Question(answer: "nine", hint: "kyu", prompt: "九"),
      Question(answer: "ten", hint: "jyuu", prompt: "十"),
    ]
    return QuestionGroup(questions: questions, title: "Numbers")
  }
}
