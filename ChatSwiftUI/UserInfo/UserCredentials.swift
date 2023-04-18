//
//  UserCredentials.swift
//  ChatSwiftUI
//
//  Created by Александр Устич on 18.04.2023.
//

import Foundation

class UserCredentials {
    static let shared = UserCredentials()
    private let emailKey = "emailKey"
    private let passwordKey = "passwordKey"
    private let defaults = UserDefaults.standard
    
    var email: String? {
        get { defaults.string(forKey: emailKey) }
        set { defaults.set(newValue, forKey: emailKey) }
    }
    
    var password: String? {
        get { defaults.string(forKey: passwordKey) }
        set { defaults.set(newValue, forKey: passwordKey) }
    }
    
    func clear() {
        defaults.removeObject(forKey: emailKey)
        defaults.removeObject(forKey: passwordKey)
    }
}

