//
//  User.swift
//  TourMate
//
//  Created by Keane Chan on 13/3/22.
//

import FirebaseFirestoreSwift

struct FirebaseAdaptedUser: FirebaseAdaptedData {
    static let type = FirebaseAdaptedType.firebaseAdaptedUser

    var id: String
    let name: String
    let email: String
    let password: String
}
