//
//  ContentView.swift
//  FirebaseIntro
//
//  Created by Nicholas Nieminen Jönsson on 2024-10-08.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var db: DbConnection
    
    var body: some View {
        
        if db.currentUser != nil {
            NavigationStack {
                //Inloggad view
                HomeView()
            }
        } else {
            NavigationStack {
                // Utloggad view
                LoginView()
            }
        }
        
    }
}

#Preview {
    ContentView().environmentObject(DbConnection())
}
