import SwiftUI

struct SearchView<Model: MapSearchable>: View {
    @EnvironmentObject var appManager: AppManager

    @State private(set) var centerLocation: Locatable
    @State private var searchRadius: SearchRadius = .fiveMiles
    @State private var searchQuery: String = ""

    @State private var isShowingErrorAlert = false

    @StateObject private var viewModel: SearchViewModel<Model>

    private var showEmptyView: Bool {
        viewModel.suggestedPlaces == nil && viewModel.searchResults.isEmpty
    }

    var body: some View {
        ZStack {
            if showEmptyView {
                Text("Start your search!")
                    .padding()
            }

            if let suggestedPlaces = viewModel.suggestedPlaces, !suggestedPlaces.isEmpty {
                PlaceSearchResultsListView(places: suggestedPlaces)
            }

            if !viewModel.searchResults.isEmpty {
                // not sure how to make this fully generic
                SearchResultsView<Model, BreweryCell>(showUserLocation: appManager.locationService.isAuthorized,
                                  mapRadius: searchRadius,
                                  centerLocation: centerLocation,
                                  searchResults: viewModel.searchResults) {
                    BreweryCell(name: "")
                }
            }
        }
        .navigationTitle("Search")
        .ignoresSafeArea(.container, edges: .bottom)
        .searchable(text: $searchQuery)
        .onChange(of: searchQuery) { newQuery in
            viewModel.getLocations(query: newQuery,
                                   baseLatitude: appManager.locationService.userLocation.latitude,
                                   baseLongitude: appManager.locationService.userLocation.longitude,
                                   searchRadius: searchRadius)
        }
        .onChange(of: viewModel.errorDescription) { description in
            isShowingErrorAlert = description != nil
        }
        .onAppear {
            appManager.locationService.request()
        }
        .alert(isPresented: $isShowingErrorAlert) {
            Alert(title: Text("Error"),
                  message: Text(viewModel.errorDescription ?? "Please try again later"),
                  dismissButton: .default(Text("OK")))
        }
    }
}

//struct SearchView_Previews: PreviewProvider {
//    static var previews: some View {
//        let user = TestUser.saulGoodman.get()
//        SearchView<Place>(centerLocation: Model(uuid: "uuid", name: "Location",
//                                       latitude: user.defaultLatitude, longitude: user.defaultLongitude))
//    }
//}


struct BreweryCell: SearchResultCell {
    let name: String

    func configure<Model>(with model: Model) -> BreweryCell where Model : MapSearchable {
        guard let brewery = model as? Brewery else { return BreweryCell(name: "") }
        return BreweryCell(name: brewery.name)
    }

    var body: some View {
        VStack(alignment: .leading) {
            Text("Name:")
            Text(name)
        }
        .padding()
    }
}
