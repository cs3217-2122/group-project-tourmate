//
//  FirebaseUpvoteService.swift
//  TourMate
//
//  Created by Terence Ho on 7/4/22.
//

import Foundation

class FirebasePlanUpvoteService: PlanUpvoteService {
    required init() {

    }

    private let planUpvoteRepository = FirebaseRepository(collectionId: FirebaseConfig.upvoteCollectionId)

    private let planUpvoteAdapter = PlanUpvoteAdapter()

    weak var planUpvoteEventDelegate: PlanUpvoteEventDelegate?

    func fetchPlanUpvotesAndListen(withPlanId planId: String, withPlanVersion planVersion: Int) async {
        print("[FirebasePlanUpvoteService] Fetching and listening to plan upvotes")

        planUpvoteRepository.eventDelegate = self
        await planUpvoteRepository.fetchItemsAndListen(field1: "planId", isEqualTo: planId,
                                                       field2: "planVersion", isEqualTo: planVersion)
    }

    func fetchPlanUpvotesAndListen(withPlanId planId: String) async {
        planUpvoteRepository.eventDelegate = self
        await planUpvoteRepository.fetchItemsAndListen(field: "planId", isEqualTo: planId)
    }

    func addPlanUpvote(planUpvote: PlanUpvote) async -> (Bool, String) {
        await planUpvoteRepository.addItem(id: planUpvote.id,
                                           item: planUpvoteAdapter.toAdaptedPlanUpvote(planUpvote: planUpvote))
    }

    func deletePlanUpvote(planUpvote: PlanUpvote) async -> (Bool, String) {
        await planUpvoteRepository.deleteItem(id: planUpvote.id)
    }

    func updatePlanUpvote(planUpvote: PlanUpvote) async -> (Bool, String) {
        await planUpvoteRepository.updateItem(id: planUpvote.id,
                                              item: planUpvoteAdapter.toAdaptedPlanUpvote(planUpvote: planUpvote))
    }

    func detachListener() {
        planUpvoteRepository.eventDelegate = nil
        planUpvoteRepository.detachListener()
    }
}

// MARK: - FirebaseEventDelegate
extension FirebasePlanUpvoteService: FirebaseEventDelegate {
    func update(items: [FirebaseAdaptedData], errorMessage: String) async {
        print("[FirebasePlanUpvoteService] Updating Plan upvotes")

        guard errorMessage.isEmpty else {
            await planUpvoteEventDelegate?.update(planUpvotes: [], errorMessage: errorMessage)
            return
        }

        guard let adaptedPlanUpvotes = items as? [FirebaseAdaptedPlanUpvote] else {
            await planUpvoteEventDelegate?.update(planUpvotes: [], errorMessage: Constants.errorPlanUpvoteConversion)
            return
        }

        let planUpvotes = adaptedPlanUpvotes.map({ planUpvoteAdapter.toPlanUpvote(adaptedPlanUpvote: $0) })

        await planUpvoteEventDelegate?.update(planUpvotes: planUpvotes, errorMessage: "")
    }

    func update(item: FirebaseAdaptedData?, errorMessage: String) async {}
}
