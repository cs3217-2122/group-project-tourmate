//
//  FirebaseCommentService.swift
//  TourMate
//
//  Created by Terence Ho on 26/3/22.
//

import Foundation

struct FirebaseCommentService: CommentService {

    @Injected(\.commentRepository) var commentRepository: Repository

    private let commentAdapter = CommentAdapter()

    weak var commentEventDelegate: CommentEventDelegate?

    func fetchCommentsAndListen(withPlanId planId: String) async {
        print("[FirebaseCommentService] Fetching and listening to comments")

        await commentRepository.fetchItemsAndListen(field: "planId", isEqualTo: planId, callback: { items, errorMessage
            in await self.update(items: items, errorMessage: errorMessage) })
    }

    func addComment(comment: Comment) async -> (Bool, String) {
        await commentRepository.addItem(id: comment.id, item: commentAdapter.toAdaptedComment(comment: comment))
    }

    func deleteComment(comment: Comment) async -> (Bool, String) {
        await commentRepository.deleteItem(id: comment.id)
    }

    func updateComment(comment: Comment) async -> (Bool, String) {
        await commentRepository.updateItem(id: comment.id, item: commentAdapter.toAdaptedComment(comment: comment))
    }

    func detachListener() {
        commentRepository.detachListener()
    }
}

// MARK: - FirebaseEventDelegate
extension FirebaseCommentService {
    func update(items: [FirebaseAdaptedData], errorMessage: String) async {
        print("[FirebaseCommentService] Updating Comments")

        guard errorMessage.isEmpty else {
            await commentEventDelegate?.update(comments: [], errorMessage: errorMessage)
            return
        }

        guard let adaptedComments = items as? [FirebaseAdaptedComment] else {
            await commentEventDelegate?.update(comments: [], errorMessage: Constants.errorCommentConversion)
            return
        }

        let comments = adaptedComments.map({ commentAdapter.toComment(adaptedComment: $0) })

        await commentEventDelegate?.update(comments: comments, errorMessage: errorMessage)
    }

    func update(item: FirebaseAdaptedData?, errorMessage: String) async {}
}
