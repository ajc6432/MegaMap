import SwiftUI
import MapKit

enum SearchRadius: Int {
    case fiveMiles
    case tenMiles
    case twentyFiveMiles

    var meters: Double {
        let oneMileInMeters = 1609.34
        switch self {
        case .fiveMiles:
            return oneMileInMeters * 5
        case .tenMiles:
            return oneMileInMeters * 10
        case .twentyFiveMiles:
            return oneMileInMeters * 25
        }
    }
}

struct MapSearchResultsView<Model: MapSearchable>: View {
    let showUserLocation: Bool
    let mapRadius: SearchRadius
    let centerLocation: Locatable
    let searchResults: [Model]

    @StateObject private var viewModel = MapSearchResultsViewModel()

    var body: some View {
        VStack {
            Map(coordinateRegion: $viewModel.mapRegion)
                .onAppear {
                    viewModel.configure(center: centerLocation)
                }

            if !searchResults.isEmpty {
                List {
                    ForEach(searchResults, id: \.self) { model in
                        Text(model.displayName)
                    }
                }
            }
        }
    }
}

//struct MapSearchResultsView_Previews: PreviewProvider {
//    static var previews: some View {
//        MapSearchResultsView()
//    }
//}
