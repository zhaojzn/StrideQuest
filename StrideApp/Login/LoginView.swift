//
//  LoginView.swift
//  StrideApp
//
//  Created by Jason Zhao on 2024-10-15.
//

import SwiftUI

struct LoginView: View {
    var body: some View {
        ZStack{
            Image("background")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            VStack{
                HStack{
                    Text("StrideQuest")
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                        .bold()
                }
                .padding(.top, 100)
                

                Spacer()
                Spacer()
                HStack{
                    Spacer()
                    Text("Login")
                        .foregroundStyle(.white)
                    Spacer()
                }
                .padding(20)
                .background(.black)
                .cornerRadius(30)
                .padding([.leading, .trailing], 30)
                HStack{
                    Spacer()
                    Text("Sign up")
                        .foregroundStyle(.white)
                    Spacer()
                }
                .padding(20)
                .background(.black)
                .cornerRadius(30)
                .padding([.leading, .trailing], 30)
                Spacer()
            }
        }

    }
}

#Preview {
    LoginView()
}
