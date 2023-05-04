//
//  InitView.swift
//  ChatSwiftUI
//
//  Created by Александр Устич on 18.04.2023.
//

import SwiftUI
import Firebase

let db = Firestore.firestore()

struct ContentView: View {
    @State var presentWelcome = (UserCredentials.shared.email != nil && UserCredentials.shared.password != nil) ? false : true
    
    var body: some View {
        TabView {
            NavigationView {
                ChatsView(presentWelcome: $presentWelcome)
                    .fullScreenCover(isPresented: $presentWelcome) {
                        WelcomeView(presentWelcome: $presentWelcome)
                    }
            }
            .tabItem {
                Label("Chats", systemImage: "message")
            }
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.crop.circle")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(presentWelcome: false)
    }
}
