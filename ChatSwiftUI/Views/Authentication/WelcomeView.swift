//
//  WelcomeView.swift
//  ChatSwiftUI
//
//  Created by Александр Устич on 15.04.2023.
//

import SwiftUI

struct WelcomeView: View {
    @State private var isShowingLogIn = false
    @State private var isShowingRegister = false
    @State var presentChat = false
    
    @Binding var presentWelcome: Bool
    
    var body: some View {
            authenticationView
    }
    
    var authenticationView: some View {
        Group {
            VStack {
                Group {
                    Text("ChatSwiftUI")
                        .font(.title)
                        .bold()
                    VStack {
                        Button("Log In") {
                            isShowingLogIn = true
                        }
                        .frame(maxWidth: .infinity)
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                        .padding()
                        Button("Register") {
                            isShowingRegister = true
                        }
                        .font(.system(size: 20))
                        .padding(.bottom)
                    }
                }
                .frame(maxHeight: .infinity, alignment: .bottom)
            }
        }
        .sheet(isPresented: $isShowingLogIn) {
            LogInView(presentWelcome: $presentWelcome, isPresented: $isShowingLogIn)
                .presentationDetents([.medium, .large])
                .dismissKeyboard()
        }
        .sheet(isPresented: $isShowingRegister) {
            RegisterView(presentWelcome: $presentWelcome, isPresented: $isShowingRegister)
                .presentationDetents([.medium, .large])
                .dismissKeyboard()
        }
    }
}

//struct WelcomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        WelcomeView()
//    }
//}
