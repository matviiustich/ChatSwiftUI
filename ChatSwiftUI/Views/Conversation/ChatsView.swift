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
    
    @State var showTabBar: Bool = true
    
    var body: some View {
        List {
            ForEach(chats) { chat in
                NavigationLink(destination: ChatView(chat: chat, showTabBar: $showTabBar)) {
                    Text(chat.participants[0] == Auth.auth().currentUser?.email ? chat.participants[1] : chat.participants[0])
                }
            }
        }
        .onAppear(perform: {
            showTabBar = true
            if !presentWelcome {
                loadChats()
                print("Load chats")
            }
        })
        .navigationTitle("Chats")
        .navigationBarItems(leading: Button(action: {
            isCreateChatViewPresented = true
        }, label: {
            Image(systemName: "square.and.pencil")
        }))
        .sheet(isPresented: $isCreateChatViewPresented) {
            CreateChat(isCreateChatViewPresented: $isCreateChatViewPresented)
                .presentationDetents([.medium, .large])
        }
        .toolbar(showTabBar ? .visible : .hidden, for: .tabBar)
    }
    
    private func signOut() {
        let firebaseAuth = Auth.auth()
        do {
            presentWelcome = true
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
        print(chats.count)
    }
    
    private func loadChats() {
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
                    if let participants = data["participants"] as? [String], let lastMessage = data["lastMessage"] as? String {
                        return Chat(id: queryDocumentSnapshot.documentID, participants: participants, lastMessage: lastMessage)
                    }
                    return nil
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
