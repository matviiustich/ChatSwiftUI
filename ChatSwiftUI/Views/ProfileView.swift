//
//  ProfileView.swift
//  ChatSwiftUI
//
//  Created by Александр Устич on 20.04.2023.
//

import SwiftUI
import Firebase

struct ProfileView: View {
    
    @Binding var presentWelcome: Bool
    
    let user = Auth.auth().currentUser
    
    var body: some View {
        VStack {
            Text(user?.email ?? "Error")
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
            presentWelcome = true
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(presentWelcome: .constant(false))
    }
}
