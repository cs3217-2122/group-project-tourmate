//
//  UpvoteService.swift
//  TourMate
//
//  Created by Terence Ho on 7/4/22.
//

import Foundation

protocol PlanUpvoteService: Copyable {
    func fetchPlanUpvotesAndListen(withPlanId planId: String, withPlanVersion planVersion: Int) async

    func fetchPlanUpvotesAndListen(withPlanId planId: String) async

    func addPlanUpvote(planUpvote: PlanUpvote) async -> (Bool, String)

    func deletePlanUpvote(planUpvote: PlanUpvote) async -> (Bool, String)

    func updatePlanUpvote(planUpvote: PlanUpvote) async -> (Bool, String)

    var planUpvoteEventDelegate: PlanUpvoteEventDelegate? { get set }

    func detachListener()
}
