import CoreLocation
import MapKit

extension CLLocation: Locatable {
    var latitude: Double {
        coordinate.latitude
    }

    var longitude: Double {
        coordinate.longitude
    }
}

extension MKCoordinateRegion {
    init(center: CLLocation, radius: SearchRadius) {
        self.init(center: center.coordinate, latitudinalMeters: radius.meters, longitudinalMeters: radius.meters)
    }
}

extension MKMapItem: MapAnnotatable {
    var latitude: Double {
        placemark.coordinate.latitude
    }

    var longitude: Double {
        placemark.coordinate.longitude
    }

    var streetAddress: String {
        if let number = placemark.subThoroughfare,
           let street = placemark.thoroughfare {
            return [number , street].joined(separator: " ")
        }

        return placemark.thoroughfare ?? ""
    }

    var displayName: String {
        placemark.name ?? placemark.title ?? streetAddress
    }
}
