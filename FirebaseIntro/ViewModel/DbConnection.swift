//
//  DbConnection.swift
//  FirebaseIntro
//
//  Created by Nicholas Nieminen Jönsson on 2024-10-02.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class DbConnection: ObservableObject {
    
    var db = Firestore.firestore()
    var auth = Auth.auth()
    
    let COLLECTION_RESTAURANTS = "restaurants"
    let COLLECTION_USER_DATA = "user_data"

    @Published var restaurants: [Restaurant] = []
    
    @Published var currentUser: User?
    @Published var currentUserData: UserData?
    
    var userDataListener: ListenerRegistration?
    var restaurantsListener: ListenerRegistration?
    
    func signOut() {
        do {
            try auth.signOut()
            currentUser = nil
            currentUserData  = nil
        } catch let error {
            print(error)
        }
    }
    
    func addFavoriteRestaurant(resturantId: String) {
        
        guard let currentUser = currentUser else {return}
        
       db.collection(COLLECTION_USER_DATA) // Gå in i kollektionen userData
                .document(currentUser.uid) // Välj dokumentet som har samma namn som användarens id
                .updateData(["restaurants": FieldValue.arrayUnion([resturantId])]) // Ta existerande arrayen i firestore och slå ihop det med den nya arrayen vi skickar in
       
        
    }
    
    func registerUser(email: String, password: String, birthdate: String) {
        
        auth.createUser(withEmail: email, password: password) { authResult, error in
                    
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let authResult = authResult else { return }
            
            //Skapa en userData dokument i våran user_data kollektion
            //där vi döper dokumentet till denn nya användarens id
            
            let newUserDate = UserData(birthdate: birthdate, restaurants: [])
            
            do {
                try self.db.collection(self.COLLECTION_USER_DATA).document(authResult.user.uid).setData(from: newUserDate)

            } catch let error {
                print("failed to create userData \(error.localizedDescription)")
            }
        }
    }
    
    func logInUser(email: String, password: String) {
        
        auth.signIn(withEmail: email, password: password)
    }
    
    init() {
        
       let _ = auth.addStateDidChangeListener { auth, user in

            // Den här funktionen kommer köras varje gång autentiseringstillståndet i våran
            // app förändras.
            if let user = user {
                // Använaderen har loggar in
                self.currentUser = user
                self.startRestaurantListener()
                self.startUserDataListener()
                
            } else {
                // Användare har loggat ut
                self.currentUser = nil
                self.restaurantsListener?.remove()
                self.restaurantsListener = nil
                
                self.userDataListener?.remove()
                self.userDataListener = nil
                self.currentUserData = nil
            }
            
        }
    }
    
    
    
    
    func deleteRestaurant(id: String) {
        let restaurantToDelete = restaurants.first { $0.id == id }
        
        guard let restaurantToDelete = restaurantToDelete else { return }
        guard let restaurantId = restaurantToDelete.id else { return }
        
        db.collection(COLLECTION_RESTAURANTS).document(restaurantId).delete()
    }
    
    func startRestaurantListener() {
        restaurantsListener = db.collection(COLLECTION_RESTAURANTS).addSnapshotListener { snapshot, error in
            
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
            }
        }
    }
    
    func startUserDataListener() {
        guard let currentUser = currentUser else {return}
        
        userDataListener = db.collection(COLLECTION_USER_DATA).document(currentUser.uid).addSnapshotListener { snapshot, error in
            
            if let error = error {
                print("Error listening to user data \(error.localizedDescription)")
                return
            }
            
            guard let snapshot = snapshot else {return}
            
            do {
                self.currentUserData = try snapshot.data(as: UserData.self)
            } catch _ {
                print("Omvandlingsfel! kunde inte omvandla användarens data")
            }
            
        }
    }
    
    
    
    
    
}
