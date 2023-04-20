//
//  ChatsView.swift
//  ChatSwiftUI
//
//  Created by Александр Устич on 19.04.2023.
//

import SwiftUI
import Firebase

struct ChatsView: View {
    @Binding var presentWelcome: Bool
    @State private var chats: [Chat] = [
        Chat(id: 1, name: "Chat 1"),
        Chat(id: 2, name: "Chat 2"),
        Chat(id: 3, name: "Chat 3"),
        Chat(id: 4, name: "Chat 4")
    ]
    
    var body: some View {
        List {
            ForEach(chats) { chat in
                
                NavigationLink(destination: ChatView()) {
                    Text(chat.name)
                }
            }
        }
        .navigationTitle("Chats")
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
    }
}

struct Chat: Identifiable {
    let id: Int
    let name: String
}

struct ChatsView_Preview: PreviewProvider {
    static var previews: some View {
        ChatsView(presentWelcome: .constant(false))
    }
}
