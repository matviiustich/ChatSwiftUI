//
//  InitView.swift
//  ChatSwiftUI
//
//  Created by Александр Устич on 18.04.2023.
//

import SwiftUI
import Firebase

struct InitView: View {
    @State var presentWelcome = (Auth.auth().currentUser != nil) ? false : true
    
    var body: some View {
        NavigationView {
            ChatView(presentWelcome: $presentWelcome)
                .fullScreenCover(isPresented: $presentWelcome) {
                    WelcomeView(presentWelcome: $presentWelcome)
                }
        }
    }
}

struct InitView_Previews: PreviewProvider {
    static var previews: some View {
        InitView()
    }
}
