//
//  Activity.swift
//  TourMate
//
//  Created by Tan Rui Quan on 10/3/22.
//

import Foundation

struct Activity: Plan {
    var id: String
    var tripId: String
    var planType: PlanType
    var name: String = "Activity"
    var startDate: Date
    var endDate: Date?
    var timeZone: TimeZone
    var imageUrl: String?
    var status: PlanStatus
    var creationDate: Date
    var modificationDate: Date

    var venue: String?
    var address: String?
    var phone: String?
    var website: String?
}
