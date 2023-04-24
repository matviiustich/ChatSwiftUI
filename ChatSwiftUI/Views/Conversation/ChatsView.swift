//
//  ChatsView.swift
//  ChatSwiftUI
//
//  Created by Александр Устич on 19.04.2023.
//

import SwiftUI
import Firebase

struct ChatsView: View {
    
    let db = Firestore.firestore()
    
    @Binding var presentWelcome: Bool
    
    @State private var isCreateChatViewPresented: Bool = false
    @State private var chats: [Chat] = []
    
    var body: some View {
        List {
            ForEach(chats) { chat in
                
                NavigationLink(destination: ChatView(conversationID: chat.firestoreID)) {
                    Text(chat.participants[0])
                }
            }
        }
        .onAppear(perform: {
            loadChats()
        })
        .navigationTitle("Chats")
        .navigationBarItems(leading: Button(action: {
            isCreateChatViewPresented = true
        }, label: {
            Image(systemName: "square.and.pencil")
        }))
        .navigationBarItems(trailing: Button(action: {
            do {
                try Auth.auth().signOut()
                presentWelcome = true
            } catch {
                print("Error signing out")
            }
        }, label: {
            Text("Log Out")
        }))
        .sheet(isPresented: $isCreateChatViewPresented) {
            CreateChat(isCreateChatViewPresented: $isCreateChatViewPresented)
                .presentationDetents([.medium, .large])
        }
    }
    
    func loadChats() {
        let conversationsCollection = db.collection("conversations").order(by: "lastUpdate")
        let query = conversationsCollection.whereField("participants", arrayContains: Auth.auth().currentUser!.email!)
        
        query.addSnapshotListener { querySnapshot, error in
            if let e = error {
                print("There was an issue retrieving data from Firestore: \(e.localizedDescription)")
            } else {
                guard let snapshotDocuments = querySnapshot?.documents else {
                    print("No documents")
                    return
                }
                
                self.chats = snapshotDocuments.compactMap { queryDocumentSnapshot in
                    let data = queryDocumentSnapshot.data()
                    guard let participants = data["participants"] as? [String],
                          let lastMessage = data["lastMessage"] as? String else {
                        return nil
                    }
                    return Chat(participants: participants, lastMessage: lastMessage, firestoreID: queryDocumentSnapshot.documentID)
                }
            }
        }
        
    }
}

struct ChatsView_Preview: PreviewProvider {
    static var previews: some View {
        ChatsView(presentWelcome: .constant(false))
    }
}
