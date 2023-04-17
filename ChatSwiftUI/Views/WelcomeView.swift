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
    
    var body: some View {
        NavigationView {
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
                            NavigationLink(destination: ChatView(), isActive: $presentChat) {
                                EmptyView()
                            }
                        }
                    }
                    .frame(maxHeight: .infinity, alignment: .bottom)
                }
            }
            .sheet(isPresented: $isShowingLogIn) {
                LogInView(showingChat: $presentChat, isPresented: $isShowingLogIn)
                    .presentationDetents([.medium, .large])
            }
            .sheet(isPresented: $isShowingRegister) {
                RegisterView(showingChat: $presentChat, isPresented: $isShowingRegister)
                    .presentationDetents([.medium, .large])
            }
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
