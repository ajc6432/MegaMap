import MapKit

struct Place: MapSearchable {
    let latitude: Double
    let longitude: Double
    let displayName: String
    let streetAddress: String

    init(latitude: Double, longitude: Double, displayName: String, streetAddress: String) {
        self.latitude = latitude
        self.longitude = longitude
        self.displayName = displayName
        self.streetAddress = streetAddress
    }

    init(mapItem: MKMapItem) {
        self.latitude = mapItem.placemark.coordinate.latitude
        self.longitude = mapItem.placemark.coordinate.longitude
        self.displayName = mapItem.displayName
        self.streetAddress = mapItem.streetAddress
    }
}
