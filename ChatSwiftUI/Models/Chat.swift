//
//  Chat.swift
//  ChatSwiftUI
//
//  Created by Александр Устич on 22.04.2023.
//

import Foundation

struct Chat: Identifiable {
    let id: String
    let participants: [String]
    let lastMessage: String
}
