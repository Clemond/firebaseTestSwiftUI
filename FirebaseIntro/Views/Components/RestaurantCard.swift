//
//  RestaurantCard.swift
//  FirebaseIntro
//
//  Created by Nicholas Nieminen Jönsson on 2024-10-08.
//

import SwiftUI

struct RestaurantCard: View {
    
    var restaurant: Restaurant
    
    @EnvironmentObject var db: DbConnection
    
    @State var isMarked = false
    
    var body: some View {
        
        VStack {
            
//            if isMarked {
//                Image(systemName: "heart.fill").resizable().frame(width: 24, height: 24, alignment: .center).foregroundStyle(.red)
//            } else {
//                Image(systemName: "heart").resizable().frame(width: 24, height: 24, alignment: .center).foregroundStyle(.red)
//            }
//            
            AsyncImage(url: URL(string: restaurant.image), content: { image in
                
                image
                    .resizable()
                    .overlay(alignment: .bottom, content: {
                        ZStack {
                            Color(.black).opacity(0.3)
                            
                            VStack(spacing: 30){
                                
                                Text(restaurant.name).bold().font(.title).foregroundStyle(.white)
                                
                                Button(action: {
                                    print("Add to favorites")
                                    
                                    guard let restaurandId = restaurant.id else {return}
                                    
                                    db.addFavoriteRestaurant(resturantId: restaurandId)
                                    
                                }, label: {
                                    Text("Add to favorites").foregroundStyle(.white).bold()
                                })
                                
                                Button(action: {
                                    print("Test")
                                }, label: {
                                    Image(systemName:isMarked ? "heart.fill" : "heart").resizable().frame(width: 24,height: 24, alignment: .center).foregroundStyle(.red)
                                })
                            }
                        }
                    })
            }, placeholder: {
                VStack {
                    
                    Text("Loading...").foregroundStyle(.black)
                }.background(.gray)
                
            }).frame(width: 300,height: 200,alignment: .center)
                .background(.red)
                .clipShape(.buttonBorder).onAppear {
                    
                    //  isMarked = self.db.currentUserData?.restaurants.contains { $0 == restaurant.id } ?? false
                    
                    DispatchQueue.main.async {
                        self.isMarked = true
                    }
                    
                }
            
        }
    }
}

#Preview {
    RestaurantCard(restaurant: Restaurant(name: "Test", address: "testgatan", image: "https://images.pexels.com/photos/128756/pexels-photo-128756.jpeg?cs=srgb&dl=pexels-crisdip-35358-128756.jpg&fm=jpg", description: "Min description"))
}
