//
//  Location.swift
//  TourMate
//
//  Created by Tan Rui Quan on 27/3/22.
//

import Foundation

struct Location: Equatable {
    var country: String = ""
    var addressLineOne: String = ""
    var addressLineTwo: String = ""
    // full = address line one + address line two
    var addressFull: String = ""
    var longitude: Double = 0.0
    var latitude: Double = 0.0

    func isPresent() -> Bool {
        self.id != "0.0-0.0"
    }
}

extension Location: CustomStringConvertible {
    var description: String {
        """
        \(country)
        \(addressLineOne)
        \(addressLineTwo)
        """
    }
}

extension Location: Identifiable {
    public var id: String {
        "\(latitude)-\(longitude)"
    }
}
