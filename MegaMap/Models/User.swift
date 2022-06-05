import Foundation

struct User: Hashable {
    let name: String
    let uuid: String
    let defaultLatitude: Double
    let defaultLongitude: Double
    let imageAssetTitle: String

    var isEmpty: Bool {
        uuid.isEmpty
    }

    var id: String {
        uuid
    }

    static func empty() -> User {
        User(name: "", uuid: "", defaultLatitude: 0, defaultLongitude: 0, imageAssetTitle: "")
    }
}

enum TestUser: CaseIterable {
    case saulGoodman
    case lebron
    case lights

    func get() -> User {
        switch self {
        case .saulGoodman: // Albuquerque
            return User(name: "Saul Goodman", uuid: UUID().uuidString,
                        defaultLatitude: 35.0844, defaultLongitude: -106.6504,
                        imageAssetTitle: "saul")
        case .lebron: // Los Angeles
            return User(name: "Lebron James", uuid: UUID().uuidString,
                        defaultLatitude: 34.0522, defaultLongitude: -118.2437,
                        imageAssetTitle: "lebron")
        case .lights: // Toronto
            return User(name: "Lights", uuid: UUID().uuidString,
                        defaultLatitude: 43.6532, defaultLongitude: -79.3832,
                        imageAssetTitle: "lights")
        }
    }
}
