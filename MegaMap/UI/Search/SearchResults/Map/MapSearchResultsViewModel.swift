import MapKit

class MapSearchResultsViewModel: ObservableObject {
    @Published var mapRegion: MKCoordinateRegion = .init()

    func configure(center: Locatable) {
        mapRegion = MKCoordinateRegion(center: CLLocation(latitude: center.latitude, longitude: center.longitude), radius: .tenMiles)
    }
}
