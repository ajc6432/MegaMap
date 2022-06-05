import Foundation
import Combine

class SearchViewModel<Model: MapSearchable>: ObservableObject {

    private let locationBasedSearchService: LocationBasedSearchService<Model>
    private let localSearchAdapter: LocalSearchAdapterProtocol

    @Published private(set) var searchResults: [Model] = []
    @Published private(set) var suggestedPlaces: [Place]?
    @Published private(set) var errorDescription: String?

    private var subscriptions: Set<AnyCancellable> = []

    init(localSearchAdapter: LocalSearchAdapterProtocol = LocalSearchAdapter(),
         locationBasedSearchService: LocationBasedSearchService<Model>) {
        self.localSearchAdapter = localSearchAdapter
        self.locationBasedSearchService = locationBasedSearchService
    }

    func getLocations(query: String, baseLatitude: Double, baseLongitude: Double, searchRadius: SearchRadius) {
        guard !query.isEmpty else {
            suggestedPlaces = nil
            return
        }

        localSearchAdapter.performLocalSearch(withQuery: query, baseLatitude: baseLatitude, baseLongitude: baseLongitude, searchRadius: searchRadius)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.errorDescription = error.localizedDescription
                }
            }, receiveValue: { [weak self] places in
                self?.suggestedPlaces = places
            })
            .store(in: &subscriptions)
    }

    func search(latitude: Double, longitude: Double) {
        locationBasedSearchService.fetch(latitude: latitude, longitude: longitude)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.errorDescription = error.localizedDescription
                }
            }, receiveValue: { [weak self] searchResults in
                self?.searchResults = searchResults
            })
            .store(in: &subscriptions)
    }
}
