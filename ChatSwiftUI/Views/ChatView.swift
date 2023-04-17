//
//  ChatView.swift
//  ChatSwiftUI
//
//  Created by Александр Устич on 16.04.2023.
//

import SwiftUI
import Firebase

struct ChatView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var message = ""
    @State private var messages: [Message] = [
        Message(text: "Hello", isMe: false),
        Message(text: "Hi!", isMe: true),
        Message(text: "How are you?", isMe: false),
        Message(text: "I'm good, thanks. How about you?", isMe: true),
        Message(text: "I'm doing great, thanks for asking!", isMe: false)
    ]
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    LazyVStack(spacing: 15) {
                        ForEach(messages) { message in
                            ChatBubble(message: message)
                        }
                    }
                }
                .padding()
                
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
//                .padding()
            }
        }
        .navigationBarTitle("Messages")
        .navigationBarItems(trailing: Button(action: {
            do {
                try Auth.auth().signOut()
                presentationMode.wrappedValue.dismiss()
            } catch {
                print("Error signing out")
            }
        }, label: {
            Text("Log Out")
        }))
    }
    
    func sendMessage() {
        guard !message.isEmpty else {
            return
        }
        messages.append(Message(text: message, isMe: true))
        message = ""
    }
}

struct Message: Identifiable {
    let id = UUID()
    let text: String
    let isMe: Bool
}

struct ChatBubble: View {
    var message: Message
    
    var body: some View {
        HStack {
            if message.isMe {
                Spacer()
                Text(message.text)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .clipShape(ChatBubbleShape(isMe: true))
                    .padding(.trailing, 10)
            } else {
                Text(message.text)
                    .foregroundColor(.black)
                    .padding()
                    .background(Color(#colorLiteral(red: 0.9137253165, green: 0.9137256742, blue: 0.9223343134, alpha: 1)))
                    .clipShape(ChatBubbleShape(isMe: false))
                    .padding(.leading, 10)
                Spacer()
            }
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
