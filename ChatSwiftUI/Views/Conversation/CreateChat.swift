//
//  CreateChat.swift
//  ChatSwiftUI
//
//  Created by Александр Устич on 22.04.2023.
//

import SwiftUI
import Firebase

struct CreateChat: View {
    let db = Firestore.firestore()
    
    @State var email: String = ""
    @State var errorOccured: String = ""
    @Binding var isCreateChatViewPresented: Bool
    
    var body: some View {
        VStack(alignment: .center) {
            Group {
                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
            }
            .autocapitalization(.none)
            .disableAutocorrection(true)
            .padding()
            .background(Color.gray.opacity(0.2))
            .cornerRadius(10)
            Text(errorOccured)
                .foregroundColor(.red)
                .font(.system(size: 15))
                .bold()
            
            Button("New Chat") {
                if email != UserCredentials.shared.email! {
                    createChatIfNotExist(with: email)
                }
            }
        }
        .padding()
        .padding(.top, 45)
        .frame(maxHeight: .infinity, alignment: .top)
    }
    
    func createChatIfNotExist(with email: String) {
        isEmailRegistered(email: email) { isRegistered in
            if isRegistered {
                isChatExist(email: email) { isExist in
                    if isExist {
                        errorOccured = "Chat already exists"
                    } else {
                        // chat doesn't exist, create it
                        print("Creating chat")
                        let conversationsCollection = db.collection("conversations")
                        conversationsCollection.addDocument(data: [
                            "participants": [Auth.auth().currentUser!.email!, email].sorted(),
                            "lastMessage": "",
                            "lastUpdate": Timestamp(date: Date())
                        ])
                        isCreateChatViewPresented = false
                    }
                }
            } else {
                // email is not registered
                errorOccured = "Email is not registered"
            }
        }
    }

    
    private func isChatExist(email: String, completion: @escaping (Bool) -> Void) {
        let currentUserEmail = Auth.auth().currentUser!.email!
        let query = db.collection("conversations").whereField("participants", isEqualTo: [currentUserEmail, email].sorted())

        query.getDocuments { (querySnapshot, error) in
            if let _ = error {
                completion(false)
                return
            } else if let snapshot = querySnapshot {
                if !snapshot.isEmpty {
                    errorOccured = "Chat already exists"
                    completion(true)
                    return
                } else {
                    // A conversation with the same participants doesn't exist
                    completion(false)
                    return
                }
            }
        }

    }
    
    private func isEmailRegistered(email: String, completion: @escaping (Bool) -> Void) {
        Auth.auth().fetchSignInMethods(forEmail: email) { (signInMethods, error) in
            if let error = error {
                print("Error fetching sign in methods: \(error.localizedDescription)")
                completion(false)
                return
            }
            
            guard let methods = signInMethods else {
                completion(false)
                return
            }
            
            if methods.isEmpty {
                print("User with email \(email) is not registered.")
                completion(false)
            } else { 
                completion(true)
            }
        }
    }
    
    
}
//struct CreateChat_Previews: PreviewProvider {
//    static var previews: some View {
//        CreateChat()
//    }
//}
