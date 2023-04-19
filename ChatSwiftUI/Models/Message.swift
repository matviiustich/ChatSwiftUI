//
//  Message.swift
//  ChatSwiftUI
//
//  Created by Александр Устич on 18.04.2023.
//

import Foundation

struct Message: Identifiable {
    let id = UUID()
    let sender: String
    let body: String
}
