//
//  ChatSwiftUIApp.swift
//  ChatSwiftUI
//
//  Created by Александр Устич on 15.04.2023.
//

import SwiftUI
import Firebase

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct ChatSwiftUIApp: App {
    let persistenceController = PersistenceController.shared
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @State var presentWelcome: Bool = (UserCredentials.shared.email != nil && UserCredentials.shared.password != nil) ? false : true
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ChatView(presentWelcome: $presentWelcome)
                    .fullScreenCover(isPresented: $presentWelcome) {
                        WelcomeView(presentWelcome: $presentWelcome)
                    }
            }
        }
    }
}
