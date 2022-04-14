//
//  AddTransportView.swift
//  TourMate
//
//  Created by Tan Rui Quan on 10/4/22.
//

import SwiftUI

struct AddTransportView: View {
    @StateObject var viewModel: AddTransportViewModel
    var dismissAddPlanView: DismissAction

    var body: some View {
        AddPlanView(viewModel: viewModel, dismissAddPlanView: dismissAddPlanView) {
            TransportFormView(viewModel: viewModel,
                              startLocation: $viewModel.startLocation,
                              endLocation: $viewModel.endLocation)
        }
    }
}
