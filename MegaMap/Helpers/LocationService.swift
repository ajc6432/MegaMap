import Foundation
import CoreLocation
import Combine

enum LocationServiceError: Error {
    case failedToLocateDevice
}

// No protocol since it needs to be an object. Sub class for testing.

class LocationService: NSObject, ObservableObject {
    private let defaultLocation: CLLocation
    private let locationManager: CLLocationManager

    @Published private(set) var authorizationStatus: CLAuthorizationStatus
    @Published private(set) var userLocation: CLLocation
    @Published private var deviceLocation: CLLocation?

    var isAuthorized: Bool {
        [.authorizedAlways, .authorizedWhenInUse].contains(authorizationStatus)
    }

    init(user: User) {
        self.defaultLocation = .init(latitude: user.defaultLatitude, longitude: user.defaultLongitude)
        self.userLocation = defaultLocation
        self.locationManager = CLLocationManager()
        self.authorizationStatus = .notDetermined
        super.init()

        locationManager.delegate = self
        self.authorizationStatus = locationManager.authorizationStatus
    }

    func startUpdatingLocation() {
        if [.authorizedWhenInUse, .authorizedAlways].contains(locationManager.authorizationStatus) {
            self.locationManager.startUpdatingLocation()
        }
    }

    func stopUpdatingLocation() {
        self.locationManager.stopUpdatingLocation()
    }

    func request() {
        self.locationManager.requestWhenInUseAuthorization()
    }
}

extension LocationService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        authorizationStatus = status
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newestLocation = locations.last else { return }
        userLocation = newestLocation
    }
}
