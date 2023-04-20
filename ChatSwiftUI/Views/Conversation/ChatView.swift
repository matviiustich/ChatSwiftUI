//
//  ChatView.swift
//  ChatSwiftUI
//
//  Created by Александр Устич on 16.04.2023.
//

import SwiftUI
import Firebase

struct ChatView: View {
    @State private var message = ""
    
    let db = Firestore.firestore()
    @State private var messages: [Message] = []
    
    var body: some View {
        Group {
            VStack {
                ScrollView(showsIndicators: false) {
                    LazyVStack(spacing: 15) {
                        ForEach(messages) { message in
                            //                            Text(message.body)
                            ChatBubble(message: message)
                        }
                    }
                    .padding()
                    .onAppear(perform: loadMessages)
                    .animation(.default)
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
        .navigationBarTitle("Messages")

    }
    
    func sendMessage() {
        if message != "", let messageSender = Auth.auth().currentUser?.email {
            db.collection("messages").addDocument(data: [
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
        db.collection("messages").order(by: "date").addSnapshotListener { querySnapshot, error in
            if let e = error {
                print("There was an issue retrieving data from Firestore: \(e)")
            } else {
                guard let snapshotDocuments = querySnapshot?.documents else {
                    print("No documents")
                    return
                }
                self.messages = snapshotDocuments.compactMap { queryDocumentSnapshot in
                    let data = queryDocumentSnapshot.data()
                    guard let messageSender = data["sender"] as? String,
                          let messageBody = data["body"] as? String else {
                              return nil
                          }
                    return Message(sender: messageSender, body: messageBody)
                }
            }
        }
    }

    
}

struct ChatBubble: View {
    var message: Message
    
    var body: some View {
        HStack {
            Group {
                if message.sender == Auth.auth().currentUser?.email {
                    Spacer()
                    Text(message.body)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .clipShape(ChatBubbleShape(isMe: true))
                        .padding(.trailing, 10)
                } else {
                    Text(message.body)
                        .foregroundColor(.black)
                        .padding()
                        .background(Color(#colorLiteral(red: 0.9137253165, green: 0.9137256742, blue: 0.9223343134, alpha: 1)))
                        .clipShape(ChatBubbleShape(isMe: false))
                        .padding(.leading, 10)
                    Spacer()
                }
            }
            .contextMenu(menuItems: {
                Button(action: {
                    let generator = UIImpactFeedbackGenerator(style: .medium)
                    generator.impactOccurred()
                }) {
                    Label("Share", systemImage: "square.and.arrow.up")
                }
            })
        }
        
    }
}

struct ChatBubbleShape: Shape {
    var isMe: Bool
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: [.topLeft, .bottomLeft, isMe ? .bottomRight : .topRight], cornerRadii: CGSize(width: 20, height: 20))
        return Path(path.cgPath)
    }
}

struct ChatView_Preview: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}