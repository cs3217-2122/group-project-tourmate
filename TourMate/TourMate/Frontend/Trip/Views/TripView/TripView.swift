//
//  TripView.swift
//  Tourmate
//
//  Created by Rayner Lim on 7/3/22.
//

import SwiftUI

struct TripView: View {
    @Environment(\.dismiss) var dismiss

    @StateObject var viewModel: TripViewModel

    @State private var isShowingAddPlanSheet = false
    @State private var isShowingEditTripSheet = false
    @State private var isShowingInviteUsersSheet = false

    init(tripViewModel: TripViewModel) {
        self._viewModel = StateObject(wrappedValue: tripViewModel)
    }

    @ViewBuilder
    var body: some View {
        Group {
            if viewModel.hasError {
                Text("Error occurred")
            } else if viewModel.isLoading || viewModel.isDeleted {
                ProgressView()
            } else {
                ScrollView {
                    VStack {
                        Text(viewModel.trip.durationDescription)
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding([.bottom, .horizontal])

                        if let imageUrl = viewModel.trip.imageUrl {
                            AsyncImage(url: URL(string: imageUrl)) { image in
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(height: 200, alignment: .center)
                                    .clipped()
                            } placeholder: {
                                Color.gray
                            }
                        }

                        AttendeesView(viewModel: viewModel)

                        PlansListView(tripId: viewModel.trip.id, tripViewModel: viewModel)
                    }
                }
            }
        }
        .navigationTitle(viewModel.trip.name)
        .toolbar {
            ToolbarItemGroup(placement: .primaryAction) {
                Button {
                    isShowingEditTripSheet.toggle()
                } label: {
                    Image(systemName: "pencil").contentShape(Rectangle())
                }
                .disabled(viewModel.isDeleted || viewModel.isLoading)
                .sheet(isPresented: $isShowingEditTripSheet) {
                    EditTripView(trip: viewModel.trip)
                }

                Button {
                    isShowingInviteUsersSheet.toggle()
                } label: {
                    Image(systemName: "person.crop.circle.badge.plus")
                }
                .disabled(viewModel.isDeleted || viewModel.isLoading)
                .sheet(isPresented: $isShowingInviteUsersSheet) {
                    InviteUserView(trip: viewModel.trip)
                }

                Button {
                    isShowingAddPlanSheet.toggle()
                } label: {
                    Image(systemName: "note.text.badge.plus")
                }
                .disabled(viewModel.isDeleted || viewModel.isLoading)
                .sheet(isPresented: $isShowingAddPlanSheet) {
                    AddPlanView(trip: viewModel.trip)
                }
            }
        }
        .task {
            await viewModel.fetchTripAndListen()
        }
        .onReceive(viewModel.objectWillChange) {
            if viewModel.isDeleted {
                dismiss()
            }
        }
        .onDisappear(perform: { () in viewModel.detachListener() })
    }
}

// struct TripView_Previews: PreviewProvider {
//    static var previews: some View {
//        TripView(trip).environmentObject(MockModel())
//    }
// }
