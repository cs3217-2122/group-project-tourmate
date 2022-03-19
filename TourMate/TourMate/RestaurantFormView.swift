//
//  RestaurantFormView.swift
//  TourMate
//
//  Created by Tan Rui Quan on 13/3/22.
//

import SwiftUI

struct RestaurantFormView: View {
    @StateObject var addPlanViewModel = AddPlanViewModel()

    @Binding var isActive: Bool

    let tripId: String

    @State private var isConfirmed = true
    @State private var restaurantName = ""
    @State private var date = Date()
    @State private var address = ""
    @State private var phone = ""
    @State private var website = ""

    private func createRestaurant() -> Restaurant {
        let planId = tripId + UUID().uuidString
        let timeZone = TimeZone.current
        let status = isConfirmed ? PlanStatus.confirmed : PlanStatus.proposed
        let creationDate = Date()
        let restaurant = Restaurant(id: planId, tripId: tripId,
                                    planType: .restaurant,
                                    name: restaurantName,
                                    startDate: date,
                                    timeZone: timeZone,
                                    status: status,
                                    creationDate: creationDate,
                                    modificationDate: creationDate,
                                    address: address,
                                    phone: phone,
                                    website: website)
        return restaurant
    }

    var body: some View {
        Form {
            Toggle("Confirmed?", isOn: $isConfirmed)
            TextField("Restaurant Name", text: $restaurantName)
            DatePicker("Date",
                       selection: $date,
                       displayedComponents: [.date, .hourAndMinute])
            TextField("Address", text: $address)
            TextField("Phone", text: $phone)
            TextField("website", text: $website)
        }
        .navigationTitle("Restaurant")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    Task {
                        await addPlanViewModel.addPlan(createRestaurant())
                        isActive = false
                    }
                }
                .disabled(addPlanViewModel.isLoading || addPlanViewModel.hasError)
            }
        }
    }
}

// struct RestaurantFormView_Previews: PreviewProvider {
//    static var previews: some View {
//        RestaurantFormView()
//    }
// }
