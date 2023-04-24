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
    @State var emailError: String = ""
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
            Text(emailError)
                .foregroundColor(.red)
                .font(.system(size: 15))
                .bold()
            
            Button("New Chat") {
                isEmailRegistered(email: email) { isRegistered in
                    print(isRegistered)
                    if isRegistered {
                        let conversationsCollection = db.collection("conversations")
                        conversationsCollection.addDocument(data: [
                            "participants": [Auth.auth().currentUser!.email, email], // an array of user emails participating in the conversation
                            "lastMessage": "", // the text of the last message sent in the conversation
                            "lastUpdate": Timestamp(date: Date()), // a timestamp indicating when the conversation was last updated
                        ])
                        isCreateChatViewPresented = false
                    } else {
                        emailError = "No users found with this email"
                    }
                }
                
            }
        }
        .padding()
        .padding(.top, 45)
        .frame(maxHeight: .infinity, alignment: .top)
    }
    
    private func isEmailRegistered(email: String, completion: @escaping (Bool) -> Void) {
        Auth.auth().fetchSignInMethods(forEmail: email) { (signInMethods, error) in
            if let error = error {
                print("Error fetching sign in methods: \(error.localizedDescription)")
                completion(false)
                return
            }
            
            guard let methods = signInMethods else {
                print("Sign in methods for email \(email) is nil.")
                completion(false)
                return
            }
            
            if methods.isEmpty {
                print("User with email \(email) is not registered.")
                completion(false)
            } else {
                print("User with email \(email) is already registered with the following sign-in methods: \(methods)")
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
