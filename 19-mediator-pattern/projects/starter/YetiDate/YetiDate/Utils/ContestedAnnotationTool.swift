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

public struct ContestedAnnotationTool {

  private static let radiusOfEarth = Double(6378100)

  public static func distributeOverlappingAnnotations(_ annotations: [BusinessMapViewModel]) -> [BusinessMapViewModel] {
    let coordinateToAnnotations = groupAnnotations(annotations)
    var newAnnotations = [BusinessMapViewModel]()
    for (_, annotationsAtCoordinate) in coordinateToAnnotations {
      let newAnnotationsAtCoordinate = distributeAnnotations(annotationsAtCoordinate)
      newAnnotations.append(contentsOf: newAnnotationsAtCoordinate)
    }
    return newAnnotations
  }

  private static func groupAnnotations(_ annotations: [BusinessMapViewModel]) -> [CLLocationCoordinate2D: [BusinessMapViewModel]] {
    var coordinateToAnnotations = [CLLocationCoordinate2D: [BusinessMapViewModel]]()
    for annotation in annotations {
      let coordinate = annotation.coordinate
      let annotationsAtCoordinate = coordinateToAnnotations[coordinate] ?? [BusinessMapViewModel]()
      coordinateToAnnotations[coordinate] = annotationsAtCoordinate + [annotation]
    }
    return coordinateToAnnotations
  }

  private static func distributeAnnotations(_ annotations: [BusinessMapViewModel]) -> [BusinessMapViewModel] {
    var newAnnotations: [BusinessMapViewModel] = []
    let coordinates = annotations.map { $0.coordinate }
    let newCoordinates = distributeCoordinates(coordinates)
    for (i, annotation) in annotations.enumerated() {
      let newCoordinate = newCoordinates[i]
      annotation.coordinate = newCoordinate
      newAnnotations.append(annotation)
    }
    return newAnnotations
  }

  private static func distributeCoordinates(_ coordinates: [CLLocationCoordinate2D]) -> [CLLocationCoordinate2D] {
    if coordinates.count == 1 {
      return coordinates
    }
    var result = [CLLocationCoordinate2D]()
    let distanceFromContestedLocation: Double = 3.0 * Double(coordinates.count) / 2.0
    let radiansBetweenAnnotations = (Double.pi * 2) / Double(coordinates.count)
    for (i, coordinate) in coordinates.enumerated() {
      let bearing = radiansBetweenAnnotations * Double(i)
      let newCoordinate = calculateCoordinate(from: coordinate,
                                              bearingInRadians: bearing,
                                              distanceInMeters: distanceFromContestedLocation)
      result.append(newCoordinate)
    }
    return result
  }

  private static func calculateCoordinate(from coordinate: CLLocationCoordinate2D,
                                          bearingInRadians bearing: Double,
                                          distanceInMeters distance: Double) -> CLLocationCoordinate2D {

    let coordinateLatitudeInRadians = coordinate.latitude * Double.pi / 180
    let coordinateLongitudeInRadians = coordinate.longitude * Double.pi / 180
    let distanceComparedToEarth = distance / radiusOfEarth

    let resultLatitudeInRadians = asin(sin(coordinateLatitudeInRadians) * cos(distanceComparedToEarth) +
      cos(coordinateLatitudeInRadians) * sin(distanceComparedToEarth) * cos(bearing))
    let resultLongitudeInRadians = coordinateLongitudeInRadians + atan2(sin(bearing) * sin(distanceComparedToEarth) *
      cos(coordinateLatitudeInRadians), cos(distanceComparedToEarth) - sin(coordinateLatitudeInRadians) *
        sin(resultLatitudeInRadians))

    let latitude = resultLatitudeInRadians * 180 / Double.pi
    let longitude = resultLongitudeInRadians * 180 / Double.pi
    return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
  }
}
