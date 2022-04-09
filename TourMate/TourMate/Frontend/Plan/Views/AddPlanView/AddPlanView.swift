//
//  PlanFormView.swift
//  TourMate
//
//  Created by Tan Rui Quan on 13/3/22.
//

import SwiftUI

@MainActor
struct AddPlanView: View {
    @Environment(\.dismiss) var dismissAddPlanView

    let trip: Trip
    private let viewModelFactory = ViewModelFactory()

    @State private var isShowingAddActivitySheet = false
    @State private var isShowingAddAccommodationSheet = false
    @State private var isShowingAddTransportSheet = false

    var body: some View {
        NavigationView {
            List {
                Button {
                    isShowingAddActivitySheet.toggle()
                } label: {
                    Text("Activity")
                        .prefixedWithIcon(named: "figure.walk.circle.fill")
                }
                .sheet(isPresented: $isShowingAddActivitySheet) {
                    AddActivityView(viewModel: viewModelFactory.getAddActivityViewModel(trip: trip), dismissAddPlanView: dismissAddPlanView)
                }

                Button {
                    isShowingAddAccommodationSheet.toggle()
                } label: {
                    Text("Accommodation")
                        .prefixedWithIcon(named: "bed.double.circle.fill")
                }
                .sheet(isPresented: $isShowingAddAccommodationSheet) {
                    let viewModel = viewModelFactory.getAddAccommodationViewModel(trip: trip)
                    AddAccommodationView(viewModel: viewModel, dismissAddPlanView: dismissAddPlanView)
                }

                Button {
                    isShowingAddTransportSheet.toggle()
                } label: {
                    Text("Transport")
                        .prefixedWithIcon(named: "car.circle.fill")
                }
            }
            .listStyle(.plain)
            .navigationTitle("Add a Plan")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", role: .destructive) {
                        dismissAddPlanView()
                    }
                }
            }
        }
    }
}

// struct PlanFormView_Previews: PreviewProvider {
//    static var previews: some View {
//        PlanFormView()
//    }
// }
