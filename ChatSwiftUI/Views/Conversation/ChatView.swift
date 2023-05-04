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
                            loadMessages()
                            scrollToLastMessage(proxy: proxy)
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
        
    }
    
    private func scrollToLastMessage(proxy: ScrollViewProxy) {
        DispatchQueue.main.async {
            if let lastMessage = messages.last {
                withAnimation {
                    proxy.scrollTo(lastMessage.id)
                }
            }
        }
    }
    
    private func sendMessage() {
        if message != "", let messageSender = Auth.auth().currentUser?.email {
            db.collection("conversations").document(chat.id).collection("messages").addDocument(data: [
                "sender": messageSender,
                "body": message,
                "date": Date().timeIntervalSince1970
            ]) { (error) in
                if let e = error {
                    print("The error occured while saving data to Firestore, \(e)")
                } else {
                    print("Successfully saved data")
                }
            }
        }
        message = ""
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
        ChatView(chat: Chat(id: "ADf124Dfkbj", participants: ["ivan@mail.com", "matthew@gmail.com"], lastMessage: "Bye"))
    }
}
