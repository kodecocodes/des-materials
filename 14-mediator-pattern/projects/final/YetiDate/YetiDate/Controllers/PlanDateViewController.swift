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
import UIKit
import YelpAPI

public class PlanDateViewController: UIViewController {

  // MARK: - Instance Properties
  private let locationManager = CLLocationManager()
  private lazy var searchClient = SearchClient(delegate: self)

  private var selectedBusinessForCategory: [YelpCategory: YLPBusiness] = [:]
  private var viewModelsForCategory: [YelpCategory: Set<BusinessMapViewModel>] = [:]

  // MARK: - Outlets
  @IBOutlet weak var mapView: MKMapView!

  // MARK: - View Lifecycle
  public override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    locationManager.requestWhenInUseAuthorization()
  }

  // MARK: - Actions
  @IBAction func resetPressed(_ sender: Any) {
    viewModelsForCategory = [:]
    mapView.removeAnnotations(mapView.annotations)
    searchClient.reset()
  }
}

// MARK: - MKMapViewDelegate
extension PlanDateViewController: MKMapViewDelegate {

  public func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
    centerMap(on: userLocation.coordinate)
    searchClient.update(userCoordinate: userLocation.coordinate)
  }

  private func centerMap(on coordinate: CLLocationCoordinate2D) {
    let regionRadius: CLLocationDistance = 3000
    let coordinateRegion = MKCoordinateRegion.init(center: coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
    mapView.setRegion(coordinateRegion, animated: true)
  }

  public func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    guard let viewModel = annotation as? BusinessMapViewModel else { return nil }
    let identifier = "business"
    let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) ??
      MKAnnotationView(annotation: viewModel, reuseIdentifier: identifier)
    viewModel.configure(annotationView)
    return annotationView
  }
}

// MARK: - ReviewDateDetailsViewControllerDelegate
extension PlanDateViewController: ReviewDateDetailsViewControllerDelegate {

  public func reviewDateDetailsViewControllerDone(_ controller: ReviewDateDetailsViewController) {
    searchClient.reset()
    navigationController?.popViewController(animated: true)
  }
}

// MARK: - SearchClientDelegate
extension PlanDateViewController: SearchClientDelegate {

  public func searchClient(_ searchClient: SearchClient,
                           didSelect business: YLPBusiness,
                           for category: YelpCategory) {
    removeAnnotations(for: category)
    selectedBusinessForCategory[category] = business
  }

  public func searchClient(_ searchClient: SearchClient,
                           didCreate viewModels: Set<BusinessMapViewModel>,
                           for category: YelpCategory) {
    guard viewModels != viewModelsForCategory[category] else { return }
    viewModelsForCategory[category] = viewModels
    reloadMapView()
  }

  public func searchClient(_ searchClient: SearchClient,
                           didCompleteSelection categoryToBusiness: [YelpCategory: YLPBusiness]) {
    let viewController = ReviewDateDetailsViewController
      .instanceFromStoryboard(with: categoryToBusiness, delegate: self)
    navigationController?.pushViewController(viewController, animated: true)
  }

  public func searchClient(_ searchClient: SearchClient,
                           failedFor category: YelpCategory,
                           error: Error?) {
    print("Search failed for `\(category)` with error `\(String(describing: error))`")
  }

  private func removeAnnotations(for category: YelpCategory) {
    guard let annotations = viewModelsForCategory[category] else { return }
    viewModelsForCategory[category] = nil
    mapView.removeAnnotations(Array(annotations))
  }

  private func reloadMapView() {
    var viewModels = viewModelsForCategory.reduce([BusinessMapViewModel]()) { $0 + $1.value }
    viewModels = ContestedAnnotationTool.distributeOverlappingAnnotations(viewModels)
    mapView.removeAnnotations(mapView.annotations)
    mapView.addAnnotations(viewModels)
  }
}
