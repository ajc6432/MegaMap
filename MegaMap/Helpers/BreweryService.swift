import Foundation
import Combine

enum BreweryServiceError: Error {
    case ohNo
}

// refactor into better practices -- networking isnt the point of this exercise

protocol LocationBasedSearchService {
    associatedtype Model: MapSearchable
    func fetch<Model>(latitude: Double, longitude: Double) -> AnyPublisher<[Model], Error>
}

class BreweryService: LocationBasedSearchService {
    typealias Model = Brewery

    private var subscriptions: Set<AnyCancellable> = Set<AnyCancellable>()

    func fetch<Brewery>(latitude: Double, longitude: Double) -> AnyPublisher<[Brewery], Error> {
        let urlString = "https://api.openbrewerydb.org/breweries?by_dist=\(latitude),\(longitude)&per_page=20"
        let resultPublisher = PassthroughSubject<[Brewery], Error>()

        guard let url = URL(string: urlString) else {
            resultPublisher.send(completion: .failure(BreweryServiceError.ohNo))
            return resultPublisher.eraseToAnyPublisher()
        }

        var req = URLRequest(url: url)
        req.httpMethod = "GET"

        URLSession.shared.dataTaskPublisher(for: req)
            .sink { completion in
                resultPublisher.send(completion: .failure(BreweryServiceError.ohNo))
            } receiveValue: { data, rsp in

                guard let response = rsp as? HTTPURLResponse,
                      Array(200...299).contains(response.statusCode) else {
                          resultPublisher.send(completion: .failure(BreweryServiceError.ohNo))
                          return
                      }

                do {
                    let decoder = JSONDecoder()
                    let breweries = try decoder.decode([Brewery].self, from: data) // not sure why this line claims Brewery does not conform to Decodable since it does
                    resultPublisher.send(breweries)
                } catch {
                    resultPublisher.send(completion: .failure(BreweryServiceError.ohNo))
                }
            }
            .store(in: &subscriptions)


        return resultPublisher.eraseToAnyPublisher()
    }
}
