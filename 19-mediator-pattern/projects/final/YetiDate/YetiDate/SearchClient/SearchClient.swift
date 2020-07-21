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

import YelpAPI
import CoreLocation

public class SearchClient: Mediator<SearchColleague> {

  // MARK: - Instance Properties
  public weak var delegate: SearchClientDelegate?

  // MARK: - Object Lifecycle
  public init(delegate: SearchClientDelegate) {
    self.delegate = delegate
    super.init()
    setupColleagues()
  }

  private func setupColleagues() {
    let restaurantColleague = YelpSearchColleague(
      category: .restaurants, mediator: self)
    addColleague(restaurantColleague)

    let barColleague = YelpSearchColleague(
      category: .bars, mediator: self)
    addColleague(barColleague)

    let movieColleague = YelpSearchColleague(
      category: .movieTheaters, mediator: self)
    addColleague(movieColleague)
  }

  // MARK: - Instance Methods
  public func update(userCoordinate: CLLocationCoordinate2D) {
    invokeColleagues() { colleague in
      colleague.update(userCoordinate: userCoordinate)
    }
  }

  public func reset() {
    invokeColleagues() { colleague in
      colleague.reset()
    }
  }
}

// MARK: - SearchColleagueMediating
extension SearchClient: SearchColleagueMediating {

  public func searchColleague(_ searchColleague: SearchColleague,
                              didSelect business: YLPBusiness) {

    delegate?.searchClient(self,
                           didSelect: business,
                           for: searchColleague.category)

    invokeColleagues(by: searchColleague) { colleague in
      colleague.fellowColleague(colleague, didSelect: business)
    }

    notifyDelegateIfAllBusinessesSelected()
  }

  private func notifyDelegateIfAllBusinessesSelected() {
    guard let delegate = delegate else { return }
    var categoryToBusiness: [YelpCategory : YLPBusiness] = [:]
    for colleague in colleagues {
      guard let business = colleague.selectedBusiness else {
        return
      }
      categoryToBusiness[colleague.category] = business
    }
    delegate.searchClient(self, didCompleteSelection: categoryToBusiness)
  }

  public func searchColleague(_ searchColleague: SearchColleague,
                              didCreate viewModels: Set<BusinessMapViewModel>) {

    delegate?.searchClient(self,
                           didCreate: viewModels,
                           for: searchColleague.category)
  }

  public func searchColleague(_ searchColleague: SearchColleague,
                              searchFailed error: Error?) {
    delegate?.searchClient(self,
                           failedFor: searchColleague.category,
                           error: error)
  }
}
