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
            Group {
                if !presentWelcome {
                    TabView {
                        NavigationView {
                            ChatsView(presentWelcome: $presentWelcome)
                        }
                        .tabItem {
                            Label("Chats", systemImage: "message")
                        }
                        ProfileView()
                            .tabItem {
                                Label("Profile", systemImage: "person.crop.circle")
                            }
                    }
                } else {
                    EmptyView()
                }
            }
            .fullScreenCover(isPresented: $presentWelcome, content: {
                WelcomeView(presentWelcome: $presentWelcome)
            })
            .animation(.default)
        }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(presentWelcome: false)
    }
}
