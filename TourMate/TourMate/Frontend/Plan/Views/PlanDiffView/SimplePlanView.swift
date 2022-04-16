//
//  SimplePlanView.swift
//  TourMate
//
//  Created by Keane Chan on 14/4/22.
//

import SwiftUI

@MainActor
struct SimplePlanView<T: Plan>: View {
    @ObservedObject var planViewModel: PlanViewModel<T>
    let commentsViewModel: CommentsViewModel
    let planUpvoteViewModel: PlanUpvoteViewModel

    @Binding var selectedVersion: Int

    private let viewFactory: ViewFactory

    init(planViewModel: PlanViewModel<T>, initialVersion: Binding<Int>) {
        self.planViewModel = planViewModel
        self._selectedVersion = initialVersion

        let viewModelFactory = ViewModelFactory()
        viewFactory = ViewFactory()

        self.commentsViewModel = viewModelFactory.getCommentsViewModel(planViewModel: planViewModel)
        commentsViewModel.allowUserInteraction = false

        self.planUpvoteViewModel = viewModelFactory.getPlanUpvoteViewModel(planViewModel: planViewModel)
    }

    func handleVersionChange(version: Int) {
        Task {
            await planViewModel.setVersionNumber(version)
            await commentsViewModel.filterSpecificVersionComments(version: version)
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 30.0) {
            HStack(spacing: 5.0) {
                VersionPickerView(selectedVersion: $selectedVersion,
                                  onChange: { val in handleVersionChange(version: val) },
                                  versionNumbers: planViewModel.allVersionNumbersSortedDesc)

                RestoreButtonView(planViewModel: planViewModel)

                Spacer()

                SimplePlanModifierView(planOwner: planViewModel.planOwner,
                                       planLastModifier: planViewModel.planLastModifier)
            }

            viewFactory.getSimplePlanDisplayView(planViewModel: planViewModel,
                                                 commentsViewModel: commentsViewModel,
                                                 planUpvoteViewModel: planUpvoteViewModel)
        }
        .padding()
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            // Load in after inner views are fully loaded
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                Task {
                    planViewModel.attachDelegate(delegate: commentsViewModel)
                    planViewModel.attachDelegate(delegate: planUpvoteViewModel)
                    handleVersionChange(version: selectedVersion)
                }
            }
        }
        .onDisappear {
            planViewModel.detachDelegates()
        }
    }
}
