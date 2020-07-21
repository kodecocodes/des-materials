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

open class Mediator<ColleagueType> {

  private class ColleagueWrapper {
    var strongColleague: AnyObject?
    weak var weakColleague: AnyObject?

    var colleague: ColleagueType? {
      return (weakColleague ?? strongColleague) as? ColleagueType
    }

    init(weakColleague: ColleagueType) {
      self.strongColleague = nil
      self.weakColleague = weakColleague as AnyObject
    }

    init(strongColleague: ColleagueType) {
      self.strongColleague = strongColleague  as AnyObject
      self.weakColleague = nil
    }
  }

  // MARK: - Instance Properties
  private var colleagueWrappers: [ColleagueWrapper] = []

  public var colleagues: [ColleagueType] {
    var colleagues: [ColleagueType] = []
    colleagueWrappers = colleagueWrappers.filter {
      guard let colleague = $0.colleague else { return false }
      colleagues.append(colleague)
      return true
    }
    return colleagues
  }

  // MARK: - Object Lifecycle
  public init() { }

  // MARK: - Colleague Management
  public func addColleague(_ colleague: ColleagueType,
                           strongReference: Bool = true) {
    let wrapper: ColleagueWrapper
    if strongReference {
      wrapper = ColleagueWrapper(strongColleague: colleague)
    } else {
      wrapper = ColleagueWrapper(weakColleague: colleague)
    }
    colleagueWrappers.append(wrapper)
  }

  public func removeColleague(_ colleague: ColleagueType) {
    guard let index = colleagues.firstIndex(where: {
      ($0 as AnyObject) === (colleague as AnyObject)
    }) else { return }
    colleagueWrappers.remove(at: index)
  }

  public func invokeColleagues(closure: (ColleagueType) -> Void) {
    colleagues.forEach(closure)
  }

  public func invokeColleagues(by colleague: ColleagueType,
                               closure: (ColleagueType) -> Void) {
    colleagues.forEach {
      guard ($0 as AnyObject) !== (colleague as AnyObject)
        else { return }
      closure($0)
    }
  }
}
