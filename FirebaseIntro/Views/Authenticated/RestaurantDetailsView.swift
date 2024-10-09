//
//  RestaurantDetailsView.swift
//  FirebaseIntro
//
//  Created by Nicholas Nieminen Jönsson on 2024-10-01.
//

import SwiftUI

struct RestaurantDetailsView: View {
    
    let restaurantName: String
    let restaurantAddress: String
    let restaurantDescription: String
    
    var body: some View {
        Text("New View!")
        VStack {
            Text("Name: \(restaurantName)")
            Text("Address: \(restaurantAddress)")
            Text("Description: \(restaurantDescription)")
        }
    }
}

#Preview {
    RestaurantDetailsView(restaurantName: "", restaurantAddress: "", restaurantDescription: "")
}
