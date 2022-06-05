import Foundation

protocol MapSearchable: MapAnnotatable, Decodable, Hashable {}

struct Brewery: MapSearchable {

    let id: String
    let name: String
    let urlString: String
    let phone: String
    let street: String
    let city: String
    let state: String
    let zipcode: String

    // MARK: - MapSearchable
    let latitude: Double
    let longitude: Double
    var displayName: String {
        name
    }

    var website: URL? {
        URL(string: urlString)
    }

    var fullAddress: String {
        street + "\n" + city + " " + state + " " + zipcode
    }

    private enum CodingKeys: String, CodingKey {
        case urlString = "website_url"
        case zipcode = "postal_code"
        case id, name, phone
        case street, city, state
        case latitude, longitude
    }
}
