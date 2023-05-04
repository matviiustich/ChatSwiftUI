//
//  InitView.swift
//  ChatSwiftUI
//
//  Created by Александр Устич on 18.04.2023.
//

import SwiftUI
import Firebase

let db = Firestore.firestore()

struct InitView: View {
    @State var presentWelcome = (UserCredentials.shared.email != nil && UserCredentials.shared.password != nil) ? false : true
    
    var body: some View {
        NavigationView {
            ChatsView(presentWelcome: $presentWelcome)
                .fullScreenCover(isPresented: $presentWelcome) {
                    WelcomeView(presentWelcome: $presentWelcome)
                }
        }
    }
}

struct InitView_Previews: PreviewProvider {
    static var previews: some View {
        InitView(presentWelcome: false)
    }
}
