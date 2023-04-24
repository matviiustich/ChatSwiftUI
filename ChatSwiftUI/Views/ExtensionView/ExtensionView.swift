//
//  ExtensionView.swift
//  ChatSwiftUI
//
//  Created by Александр Устич on 21.04.2023.
//

import SwiftUI

extension View {
    func dismissKeyboard() -> some View {
        modifier(DismissKeyboardModifier())
    }
}

struct DismissKeyboardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .onTapGesture {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil) // dismisses the keyboard
            }
            .gesture(DragGesture().onChanged { value in
                // Check if the gesture is a swipe down gesture
                if value.translation.height > 0 {
                    // Resign the first responder status of the text field
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
            })
    }
}
