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
    @State private var startDate = Date()
    @State private var endDate = Date()
    @State private var address = ""
    @State private var phone = ""
    @State private var website = ""

    private func createRestaurant() -> Restaurant {
        let planId = tripId + UUID().uuidString
        let status = isConfirmed ? PlanStatus.confirmed : PlanStatus.proposed
        let creationDate = Date()
        let restaurant = Restaurant(id: planId, tripId: tripId,
                                    name: restaurantName.isEmpty ? "Restaurant" : restaurantName,
                                    startDateTime: DateTime(date: startDate),
                                    endDateTime: DateTime(date: endDate),
                                    startLocation: address,
                                    status: status,
                                    creationDate: creationDate,
                                    modificationDate: creationDate,
                                    phone: phone,
                                    website: website)
        return restaurant
    }

    var body: some View {
        Form {
            Toggle("Confirmed?", isOn: $isConfirmed)
            TextField("Restaurant Name", text: $restaurantName)
            DatePicker("Start Date",
                       selection: $startDate,
                       displayedComponents: [.date, .hourAndMinute])
            DatePicker("End Date",
                       selection: $endDate,
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
