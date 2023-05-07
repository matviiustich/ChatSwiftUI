//
//  ChatView.swift
//  ChatSwiftUI
//
//  Created by Александр Устич on 16.04.2023.
//

import SwiftUI
import Firebase

struct ChatView: View {
    
    let chat: Chat
    
    @Binding var showTabBar: Bool
    
    @State private var message = ""
    @State private var messages: [Message] = []
    
    var body: some View {
        Group {
            VStack {
                ScrollViewReader { proxy in
                    ScrollView(showsIndicators: false) {
                        LazyVStack(spacing: 15) {
                            ForEach(messages) { message in
                                ChatBubble(message: message, chatID: chat.id)
                            }
                        }
                        .padding()
                        .onAppear(perform: {
                            showTabBar = false
                            loadMessages()
                        })
                        .onChange(of: messages.count, perform: { _ in
                            proxy.scrollToLastMessage(messages: messages)
                        })
                        .animation(.default)
                    }
                    
                }
                HStack(spacing: 15) {
                    TextField("Message", text: $message)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                    Button(action: sendMessage, label: {
                        Image(systemName: "arrow.up.circle.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.blue)
                    })
                    .padding()
                }
                
            }
            .animation(.default)
        }
        
        .dismissKeyboard()
        .navigationBarTitle("Messages")
        .toolbar(showTabBar ? .visible : .hidden, for: .tabBar)
        
    }
    
    private func sendMessage() {
        let messageBody = message
        if messageBody != "", let messageSender = Auth.auth().currentUser?.email {
            message = ""
            db.collection("conversations").document(chat.id).collection("messages").addDocument(data: [
                "sender": messageSender,
                "body": messageBody,
                "date": Date().timeIntervalSince1970
            ]) { (error) in
                if let e = error {
                    print("The error occured while saving data to Firestore, \(e)")
                } else {
                    let updateConversationMessageData = ["lastMessage": messageBody]
                    let updateConversationTimeDta = ["lastUpdate": Timestamp(date: Date())]

                    updateConversation(conversationID: chat.id, withData: updateConversationMessageData)
                    updateConversation(conversationID: chat.id, withData: updateConversationTimeDta)
                    print("Successfully saved data")
                }
            }
        }
    }
    
    func updateConversation(conversationID: String, withData data: [String: Any]) {
        let conversationRef = db.collection("conversations").document(conversationID)
        conversationRef.updateData(data) { error in
            if let error = error {
                print("Error updating conversation lastUpdate date: \(error)")
            } else {
                print("Conversation lastUpdate date updated successfully.")
            }
        }
    }
    
    
    
    private func loadMessages() -> Void {
        db.collection("conversations").document(chat.id).collection("messages").order(by: "date").addSnapshotListener { querySnapshot, error in
            if let e = error {
                print("There was an issue retrieving data from Firestore: \(e)")
            } else {
                guard let snapshotDocuments = querySnapshot?.documents else {
                    print("No documents")
                    return
                }
                self.messages = snapshotDocuments.compactMap { queryDocumentSnapshot in
                    let data = queryDocumentSnapshot.data()
                    if let messageSender = data["sender"] as? String, let messageBody = data["body"] as? String {
                        return Message(id: queryDocumentSnapshot.documentID, sender: messageSender, body: messageBody)
                    }
                    return nil
                }
                
            }
        }
    }
    
}

struct ChatView_Preview: PreviewProvider {
    static var previews: some View {
        ChatView(chat: Chat(id: "ADf124Dfkbj", participants: ["ivan@mail.com", "matthew@gmail.com"], lastMessage: "Bye"), showTabBar: .constant(false))
    }
}
