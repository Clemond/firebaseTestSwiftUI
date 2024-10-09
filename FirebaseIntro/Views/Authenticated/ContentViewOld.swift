//
//  ContentView.swift
//  FirebaseIntro
//
//  Created by Nicholas Nieminen Jönsson on 2024-09-30.
//

import SwiftUI
import FirebaseFirestore

struct ContentViewOld: View {
    
    var db = Firestore.firestore()
    
    let COLLECTION_RESTAURANTS = "restaurants"
    
    //  State gör så värdet kan uppdateras i UI:n
    //  Swift UI håller koll på variabeln så när en förändring sker så uppdateras variabeln överallt i appen där den finns.
    @EnvironmentObject var dbConnection: DbConnection
    
    @State var restaurants: [Restaurant] = []
    
    @State var restaurantName: String = ""
    @State var restaurantAddress: String = ""
    @State var restaurantDescription: String = ""
    @State var restaurantImage: String = ""
    
    
    
    
    /*
     Lyssna på Firebase efter förändringar, och genomföra samma förändringar i våran app. D.v.s om någon lägger in en ny restaurang i firebase så ska det även läggas till i våran app automatiskt.
     */
    
    func startListeningToDb() {
        
        db.collection(COLLECTION_RESTAURANTS).addSnapshotListener { snapshot, error in
            
            if let error = error {
                // Vi har fått ett fel
                print("Error on snapshot: \(error.localizedDescription)")
                return
            }
            
            guard let snapshot = snapshot else { return }
            
            // Vid minsta förändring i våran kollektion tas en kopia av hela kollektionen vid det ögonblick efter uppdateringen gjordes
            
            self.restaurants = []
            
            for document in snapshot.documents {
                
                // Vi får datan i form av en dictionary, och vi vill omvandla det till en Restaurant struct.
                
                do {
                    // Kommer misslyckas om datan i dokumentet inte matchar Restaurant datatypen.
                    let resturant = try document.data(as: Restaurant.self)
                    
                    self.restaurants.append(resturant)
                    
                } catch let error {
                    print("Omvandlingsfel!: \(error.localizedDescription)")
                }
                
                
                
                /*
                 
                 Result gör att vi kan kalla på något som kanske kan misslyckas (throwable), och sedan får vi resultatet i en variabel. Denna variabel innehåller antingen värdet vi önskar eller en error.
                 
                 let result = Result {
                 try document.data(as: Restaurant.self)
                 
                 }
                 
                 switch result {
                 case .success(let resturant):
                 self.restaurants.append(resturant)
                 case .failure(let error):
                 print(error.localizedDescription)
                 }
                 */
            }
            
            
        }
        
        
    }
        
        var body: some View {
            VStack {
                NavigationView {
                    List() {
                        ForEach(restaurants) { restaurant in
                            //Text(restaurant.name)
                            NavigationLink(restaurant.name, destination: RestaurantDetailsView(restaurantName: restaurant.name, restaurantAddress: restaurant.address, restaurantDescription: restaurant.description))
                        }.onDelete { IndexSet in
                            
                            for index in IndexSet {
                                let restaurantToDelete = restaurants[index]
                                
                                if let restaurantId = restaurantToDelete.id {
                                    db.collection(COLLECTION_RESTAURANTS).document(restaurantId).delete() { error in
                                        
                                        print("Restaurant has been deleted!")
                                        
                                        // Completion körs efter att operationen är slutförd
                                        
                                        // Göra något efter att dokumentet tagits bort
                                        
                                        
                                    }
                                }
                            }
                            
                        }
                    }
                }
                
                TextField("Restaurant name: ", text: $restaurantName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                TextField("Restaurant address: ", text: $restaurantAddress)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                TextField("Restaurant description: ", text: $restaurantDescription)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button("Add") {
                    
                    let newRestaurant = Restaurant(name: restaurantName, address: restaurantAddress, image: restaurantImage, description: restaurantDescription )
                    //   db.collection("restaurants").document("Hej").setData(["name" : "Hejsan"])
                    
                    do {
                        try db.collection(COLLECTION_RESTAURANTS).addDocument(from: newRestaurant)
                        
                    } catch {
                        print("Could not add restaurant \(error.localizedDescription)")
                    }
                }
                
            }
            .onAppear {
                startListeningToDb()
            }
            .padding()
        }
    }

#Preview {
    ContentViewOld()
}
