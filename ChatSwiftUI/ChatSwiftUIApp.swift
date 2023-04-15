//
//  ChatSwiftUIApp.swift
//  ChatSwiftUI
//
//  Created by Александр Устич on 15.04.2023.
//

import SwiftUI

@main
struct ChatSwiftUIApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
