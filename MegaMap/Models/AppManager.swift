import Foundation

class AppManager: ObservableObject {
    @Published private(set) var isLoggedIn: Bool
    @Published private(set) var user: User {
        didSet {
            updateUserRelatedDependencies()
        }
    }

    @Published private(set) var locationService: LocationService

    init(user: User) {
        self.user = user
        self.isLoggedIn = !user.isEmpty
        self.locationService = LocationService(user: user)
    }

    func setUser(to user: User) {
        self.user = user
    }

    func logout() {
        self.user = .empty()
    }

    private func updateUserRelatedDependencies() {
        isLoggedIn = !user.isEmpty
        locationService = LocationService(user: user)
    }
}
