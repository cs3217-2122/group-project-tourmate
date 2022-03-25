//
//  RestaurantFormView.swift
//  TourMate
//
//  Created by Tan Rui Quan on 13/3/22.
//

import SwiftUI

struct RestaurantFormView: View {
    @Binding var isActive: Bool
    @StateObject var viewModel: AddPlanFormViewModel<Restaurant>

    @State private var isConfirmed = true
    @State private var restaurantName = ""
    @State private var startDate = Date()
    @State private var endDate = Date()
    @State private var address = ""
    @State private var phone = ""
    @State private var website = ""

    var body: some View {
        Form {
            Toggle("Confirmed?", isOn: Binding<Bool>(
                get: { viewModel.plan.status == PlanStatus.confirmed },
                set: { select in
                    if select {
                        viewModel.plan.status = PlanStatus.confirmed
                    } else {
                        viewModel.plan.status = PlanStatus.proposed
                    }
                })
            )
            TextField("Restaurant Name", text: $viewModel.plan.name)
            DatePicker("Start Date",
                       selection: $viewModel.plan.startDateTime.date,
                       in: viewModel.trip.startDateTime.date...viewModel.trip.endDateTime.date,
                       displayedComponents: [.date, .hourAndMinute])
            DatePicker("End Date",
                       selection: $viewModel.plan.endDateTime.date,
                       in: viewModel.trip.startDateTime.date...viewModel.trip.endDateTime.date,
                       displayedComponents: [.date, .hourAndMinute])
            TextField("Address", text: $viewModel.plan.startLocation)
            TextField("Phone", text: $viewModel.plan.phone ?? "")
            TextField("website", text: $viewModel.plan.website ?? "")
        }
        .navigationTitle("Restaurant")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    Task {
                        await viewModel.addPlan()
                        isActive = false
                    }
                }
                .disabled(!viewModel.canAddPlan || viewModel.isLoading || viewModel.hasError)
            }
        }
    }
}

// struct RestaurantFormView_Previews: PreviewProvider {
//    static var previews: some View {
//        RestaurantFormView()
//    }
// }
