import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appManager: AppManager

    var body: some View {
        NavigationView {
            if appManager.isLoggedIn {
                SearchView<Brewery>(centerLocation: appManager.locationService.userLocation,
                                    viewModel: SearchViewModel<Brewery>(locationBasedSearchService: BreweryService()))
            } else {
                LoginView()
            }
        }
        .environmentObject(appManager)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
