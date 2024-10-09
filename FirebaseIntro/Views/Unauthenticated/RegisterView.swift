//
//  RegisterView.swift
//  FirebaseIntro
//
//  Created by Nicholas Nieminen Jönsson on 2024-10-02.
//

import SwiftUI

struct RegisterView: View {
    
    @State var email = ""
    @State var password = ""
    @State var confirmPassword = ""
    @State var birthDate = Date()
    @EnvironmentObject var db: DbConnection
    
    var body: some View {
        
        VStack (spacing: 50) {
            
            Image("hot-pot").resizable().frame(width: 150, height: 150, alignment: .center)
            
            Text("Create account!").bold().font(.system(size: 26))
            
            VStack (){
                
                VStack(alignment: .leading, spacing: 10) {
                    TextField("Email adress", text: $email)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                    
                    SecureField("Password", text: $password)
                        .textFieldStyle(.roundedBorder)
                    
                    SecureField("Confirm password", text: $confirmPassword)
                        .textFieldStyle(.roundedBorder)
                    
                    VStack(alignment: .leading){
                        Text("Birthdate: ")
                        DatePicker(selection: $birthDate, label:{
                            EmptyView()}).labelsHidden()
                        
                    }
                
                }
               // .background(.gray)
                .padding(.horizontal, 60)
                .padding(.vertical, 10)
                
                Button(action: {
                    
                    db.registerUser(email: email, password: password, birthdate: birthDate.ISO8601Format())
                    
                }) {
                    Text("Register account")
                        .bold()
                        .padding()
                        .foregroundStyle(.white)
                        .background(.black)
                        .clipShape(.buttonBorder)
                }.padding()
            }
            
        }
    
        
    }
}

#Preview {
    RegisterView()
}
