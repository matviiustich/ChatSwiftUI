//
//  ChatBubble.swift
//  ChatSwiftUI
//
//  Created by Александр Устич on 04.05.2023.
//

import SwiftUI

struct ChatBubble: View {
    var message: Message
    let chatID: String
    
    var body: some View {
        HStack {
            Group {
                if message.sender == UserCredentials.shared.email {
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
                Button {
                    let generator = UIImpactFeedbackGenerator(style: .medium)
                    generator.impactOccurred()
                    
                    // Share document
                    let text = message.body
                    let activityViewController = UIActivityViewController(activityItems: [text], applicationActivities: nil)
                    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                       let window = windowScene.windows.first {
                        window.rootViewController?.present(activityViewController, animated: true, completion: nil)
                    }
                } label: {
                    Label("Share", systemImage: "square.and.arrow.up")
                }
                Button {
                    let generator = UINotificationFeedbackGenerator()
                    generator.notificationOccurred(.success)
                    
                    delete()
                } label: {
                    Label("Delete", systemImage: "trash")
                        .foregroundColor(.red)
                }
                
            })
        }
    }
    
    func delete() {
        let conversationRef = db.collection("conversations").document(chatID)
        let messageRef = conversationRef.collection("messages").document(message.id)

        messageRef.delete() { error in
            if let error = error {
                print("Error deleting message: \(error)")
            } else {
                print("Message deleted successfully.")
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
