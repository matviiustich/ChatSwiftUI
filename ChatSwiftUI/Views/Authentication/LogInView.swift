//
//  LogInView.swift
//  ChatSwiftUI
//
//  Created by Александр Устич on 15.04.2023.
//

import SwiftUI
import Firebase

struct LogInView: View {
    
    @State var email: String = ""
    @State var password: String = ""
    @State var passwordError: String = ""
    
    @Binding var presentWelcome: Bool
    @Binding var isPresented: Bool
    
    var body: some View {
        NavigationView {
            VStack(alignment: .center) {
                Group {
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                    SecureField("Password", text: $password)
                }
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
                Text(passwordError)
                    .foregroundColor(.red)
                    .font(.system(size: 15))
                    .bold()
                
                Button("Log In") {
                    Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                        if let p = error {
                            passwordError = p.localizedDescription
                        } else {
                            passwordError = ""
                            UserCredentials.shared.email = email
                            UserCredentials.shared.password = password
                            presentWelcome = false
                            isPresented = false
                        }
                    }
                }
            }
            .padding()
            .padding(.top, 45)
            .frame(maxHeight: .infinity, alignment: .top)
        }
    }
    
}

struct LogInView_Previews: PreviewProvider {
    static var previews: some View {
        LogInView(presentWelcome: .constant(false), isPresented: .constant(true))
    }
}
