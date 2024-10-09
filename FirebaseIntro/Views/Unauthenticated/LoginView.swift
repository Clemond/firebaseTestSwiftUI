//
//  LoginView.swift
//  FirebaseIntro
//
//  Created by Nicholas Nieminen Jönsson on 2024-10-02.
//

import SwiftUI

struct LoginView: View {
    
    @State var email = ""
    @State var password = ""
    @EnvironmentObject var db: DbConnection
    
    var body: some View {
        VStack (spacing: 50) {
            
            Image("hot-pot").resizable().frame(width: 150, height: 150, alignment: .center)
                .shadow(radius: 20)
            
            Text("Login!").bold().font(.system(size: 26))
            
            VStack {
                TextField("Email adress", text: $email)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                
                SecureField("Password", text: $password)
                    .textFieldStyle(.roundedBorder)
            }
            .padding(.horizontal, 60)
            .padding(.vertical, 30)
            .background(.gray.opacity(0.5))
            .clipShape(.rect(cornerRadius: 50))
            
            Button(action: {
                
                db.logInUser(email: email, password: password)
                
                print("Clicked")
            }) {
                Text("Log in")
                    .bold()
                    .padding()
                    .foregroundStyle(.white)
                    .background(.black)
                    .clipShape(.buttonBorder)
            }.padding()
            
                NavigationLink(destination: {RegisterView()}) {
                    Text("Register account").foregroundStyle(Color.black)
                }
            }
            
        
    
        
    }
}

#Preview {
    LoginView().environmentObject(DbConnection())
}
