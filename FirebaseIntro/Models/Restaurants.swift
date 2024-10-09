//
//  Restaurants.swift
//  FirebaseIntro
//
//  Created by Nicholas Nieminen Jönsson on 2024-09-30.
//

import Foundation
import FirebaseFirestore

// Decodable - omvandlar den externa representationen till våran struct.
// Med andra ord kan vi skapa instanser av våran struct från en extern representation.

// Encodable - omvandlar en instans av våran struct till den externa representationen.
// Med andra ord kan vi ladda upp direkt från våran Restaurant.

struct Restaurant: Codable, Identifiable {
    @DocumentID var id: String?
    var name: String
    var address: String
    var image: String
    var description: String
}
