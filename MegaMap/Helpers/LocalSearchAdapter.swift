import CoreLocation
import MapKit
import Combine

protocol LocalSearchAdapterProtocol {
    func performLocalSearch(withQuery query: String, baseLatitude: Double, baseLongitude: Double, searchRadius: SearchRadius) -> AnyPublisher<[Place], Error>
}

struct LocalSearchAdapter: LocalSearchAdapterProtocol {
    func performLocalSearch(withQuery query: String,
                            baseLatitude: Double, baseLongitude: Double,
                            searchRadius: SearchRadius) -> AnyPublisher<[Place], Error> {
        let pub = PassthroughSubject<[Place], Error>()

        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = query
        searchRequest.region = MKCoordinateRegion(center: CLLocation(latitude: baseLatitude, longitude: baseLongitude), radius: searchRadius)

        MKLocalSearch(request: searchRequest).start { response, error in

//            if let error = error {
//                pub.send(completion: .failure(error))
//                return
//            }

            if let response = response {
                pub.send(response.mapItems.map { Place(mapItem: $0) })
            }

        }

        return pub.eraseToAnyPublisher()
    }
}
