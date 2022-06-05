import SwiftUI

struct PlaceSearchResultsListView: View {
    let places: [Place]

    var body: some View {
        List {
            ForEach(places, id: \.self) { place in
                VStack(alignment: .leading) {
                    Text(place.displayName)
                        .font(.system(.headline))

                    Text(place.streetAddress)
                        .font(.system(.subheadline))
                }
                .onTapGesture {
                    // select this place and use it to search
                }
            }
        }
    }
}

struct LocationSearchResultsListView_Previews: PreviewProvider {
    static var previews: some View {
        let nullIsland = Place(latitude: 0, longitude: 0, displayName: "Null Island", streetAddress: "In the ocean")
        PlaceSearchResultsListView(places: [nullIsland, nullIsland])
    }
}
