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

import MapKit
import YelpAPI

public class BusinessMapViewModel: NSObject {
  public let business: YLPBusiness
  public var coordinate: CLLocationCoordinate2D
  public let primaryCategory: YelpCategory
  public let onSelect: () -> Void

  public init(business: YLPBusiness,
              coordinate: YLPCoordinate,
              primaryCategory: YelpCategory,
              onSelect: @escaping (YLPBusiness) -> Void) {
    self.business = business
    self.coordinate = CLLocationCoordinate2D(latitude: coordinate.latitude,
                                             longitude: coordinate.longitude)
    self.primaryCategory = primaryCategory
    self.onSelect = { onSelect(business) }
  }
}

// MARK: - Equatable
extension BusinessMapViewModel {
  public override func isEqual(_ object: Any?) -> Bool {
    guard let comparison = object as? BusinessMapViewModel else { return false }
    return business.name == comparison.business.name &&
      coordinate == comparison.coordinate &&
      primaryCategory == comparison.primaryCategory
  }
}

// MARK: - Hashable
extension BusinessMapViewModel {
  public override var hash: Int {
    return business.identifier.hash
  }
}

// MARK: - MKAnnotation
extension BusinessMapViewModel: MKAnnotation {

  public var title: String? {
    return business.name
  }

  public var subtitle: String? {
    return "\(business.rating) stars"
  }
}

// MARK: - View Conveniences
extension BusinessMapViewModel {
  public func configure(_ view: MKAnnotationView) {
    view.canShowCallout = true
    view.image = primaryCategory.smallIcon
    let button = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
    button.setImage(#imageLiteral(resourceName: "ic_circle_check"), for: .normal)
    button.addTarget(self, action: #selector(BusinessMapViewModel.handleButtonPressed), for: .touchUpInside)
    view.rightCalloutAccessoryView = button
  }

  @objc private func handleButtonPressed() {
    onSelect()
  }
}
