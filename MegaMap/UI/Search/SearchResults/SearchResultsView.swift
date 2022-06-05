import SwiftUI

struct SearchResultsView<Model: MapSearchable, CellTemplate: SearchResultCell>: View {

    private let showUserLocation: Bool
    private let mapRadius: SearchRadius
    private let centerLocation: Locatable
    private let searchResults: [Model]
    private let searchResultCell: CellTemplate

    init(
        showUserLocation: Bool,
        mapRadius: SearchRadius,
        centerLocation: Locatable,
        searchResults: [Model],
        @ViewBuilder searchResultCell: () -> CellTemplate
    ) {
        self.showUserLocation = showUserLocation
        self.mapRadius = mapRadius
        self.centerLocation = centerLocation
        self.searchResults = searchResults
        self.searchResultCell = searchResultCell()
    }

    var body: some View {
        VStack {
            MapSearchResultsView<Model>(showUserLocation: showUserLocation,
                                       mapRadius: mapRadius,
                                       centerLocation: centerLocation,
                                       searchResults: searchResults)

            if !searchResults.isEmpty {
                List {
                    ForEach(searchResults, id: \.self) { model in
                        searchResultCell.configure(with: model)
                    }
                }
            }
        }
    }
}

protocol SearchResultCell: View {
    func configure<Model: MapSearchable>(with model: Model) -> Self
}

struct Thing: Hashable {
    let uuid: String = UUID().uuidString
}

struct ThingCell: SearchResultCell {
    @State private var thing: Thing?
    func configure<Model>(with model: Model) -> ThingCell where Model : MapSearchable {
        if let newThing = model as? Thing {
            self.thing = newThing
        }
        return self
    }

    var body: some View {
        if let thing = thing {
            Text("Thing has uuid: \(thing.uuid)")
        } else {
            Text("Thing is null")
        }
    }
}
