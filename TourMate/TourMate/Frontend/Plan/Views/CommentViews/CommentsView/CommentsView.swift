//
//  CommentsView.swift
//  TourMate
//
//  Created by Terence Ho on 26/3/22.
//

import SwiftUI

// Entire Comments View
struct CommentsView: View {
    @StateObject var viewModel: CommentsViewModel
    private let viewModelFactory = ViewModelFactory()

    var body: some View {
        if viewModel.hasError {
            Text("Error Occurred")
        } else {
            VStack(spacing: 15.0) {
                CommentListView(viewModel: viewModel)

                if viewModel.allowUserInteraction {
                    AddCommentView(viewModel: viewModelFactory.getAddCommentViewModel(commentsViewModel: viewModel))
                }
            }
            .padding()
            .background(.thinMaterial)
            .cornerRadius(20.0)
        }
    }
}

// struct CommentsView_Previews: PreviewProvider {
//    static var previews: some View {
//        CommentsView()
//    }
// }
