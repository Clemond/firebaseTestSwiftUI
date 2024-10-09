//
//  HomeView.swift
//  FirebaseIntro
//
//  Created by Nicholas Nieminen Jönsson on 2024-10-02.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var db: DbConnection
    
    var body: some View {
            ScrollView {
            Text("All restaurants").font(.title2)
            
                ForEach(db.restaurants) { restaurant in
                    
                    RestaurantCard(restaurant: restaurant)
                    
                }
            
            

            Button(action: {
                db.signOut()
            }, label: {
                Text("Log out")
                    .padding()
                    .foregroundStyle(Color.white)
                    .background(.red)
                    .clipShape(.buttonBorder)
            })
        
            }.padding()
        
        
    }
}

#Preview {
    HomeView().environmentObject(DbConnection())
}
