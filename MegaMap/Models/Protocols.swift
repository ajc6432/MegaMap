import Foundation

protocol Locatable {
    var latitude: Double { get }
    var longitude: Double { get }
}

protocol MapAnnotatable: Locatable {
    var latitude: Double { get }
    var longitude: Double { get }
    var displayName: String { get }
}
