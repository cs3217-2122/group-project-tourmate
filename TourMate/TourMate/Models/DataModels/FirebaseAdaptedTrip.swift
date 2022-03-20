//
//  FirebaseAdaptedTrip.swift
//  TourMate
//
//  Created by Tan Rui Quan on 11/3/22.
//

import Foundation

struct FirebaseAdaptedTrip: FirebaseAdaptedData {
    let id: String
    let name: String
    let startDate: Date
    let endDate: Date
    let timeZone: TimeZone
    let imageUrl: String?
    let attendeesUserIds: [String]
    let invitedUserIds: [String]
    let creationDate: Date
    let modificationDate: Date

    func getType() -> FirebaseAdaptedType {
        FirebaseAdaptedType.firebaseAdaptedTrip
    }
}