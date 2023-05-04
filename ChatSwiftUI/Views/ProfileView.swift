//
//  ProfileView.swift
//  ChatSwiftUI
//
//  Created by Александр Устич on 20.04.2023.
//

import SwiftUI
import Firebase

struct ProfileView: View {
    
    var body: some View {
        VStack {
            Text("\(UserCredentials.shared.email!)")
                .font(.system(size: 15))
                .padding()
            Button {
                signOut()
            } label: {
                Text("Log out")
            }
        }
    }
    
    private func signOut() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            UserCredentials.shared.clear()
            UIApplication.shared.windows.first?.rootViewController = UIHostingController(rootView: ContentView())
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
