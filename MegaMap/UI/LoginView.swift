import SwiftUI

struct LoginView: View {
    @EnvironmentObject var appManager: AppManager

    private let testUsers: [User] = TestUser.allCases.map { $0.get() }

    var body: some View {
        List {
            Section(header: Text("Test Users")) {
                ForEach(testUsers, id: \.self) { testUser in

                    Button {
                        appManager.setUser(to: testUser)
                    } label: {
                        HStack {
                            Image(testUser.imageAssetTitle)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 52, height: 52)
                                .padding(8)

                            Text(testUser.name)
                        }
                        .frame(height: 60)
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
        .navigationBarTitle("Log in")
        .environmentObject(appManager)

        Spacer()
    }
}


struct LoginViewModel {
    @EnvironmentObject var appManager: AppManager

    func login(user: User) {
        appManager.setUser(to: user)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
