//
//  FirebasePersistenceManager.swift
//  TourMate
//
//  Created by Keane Chan on 13/3/22.
//

import Firebase

struct FirebasePersistenceManager: PersistenceManager {
    let collectionId: String

    private let db = Firestore.firestore()

    @MainActor
    func addItem<T: FirebaseAdaptedData>(id: String, item: T) async -> (hasAddedItem: Bool, errorMessage: String) {
        guard Auth.auth().currentUser != nil else {
            return (false, Constants.messageUserNotLoggedIn)
        }

        do {
            let itemRef = db.collection(collectionId).document(id)
            let any = AnyFirebaseAdaptedData(item)
            try itemRef.setData(from: any)

            print("[FirebasePersistenceManager] Added \(T.self): \(itemRef)")

            return (true, "")
        } catch {
            let errorMessage = "[FirebasePersistenceManager] Error adding \(T.self): \(error)"
            return (false, errorMessage)
        }
    }

    @MainActor
    func fetchItem(id: String) async -> (item: FirebaseAdaptedData?, errorMessage: String) {
        guard Auth.auth().currentUser != nil else {
            return (nil, Constants.messageUserNotLoggedIn)
        }

        do {
            let itemRef = db.collection(collectionId).document(id)
            let item = try await itemRef.getDocument().data(as: AnyFirebaseAdaptedData.self).map { $0.base }

            print("[FirebasePersistenceManager] Fetched: \(itemRef)")

            return (item, "")
        } catch {
            let errorMessage = "[FirebasePersistenceManager] Error fetching: \(error)"
            return (nil, errorMessage)
        }
    }

    @MainActor
    func fetchItems(field: String, arrayContains id: String) async -> (items: [FirebaseAdaptedData],
                                                                       errorMessage: String) {
        // Might want to remove the hard coding here in the future
        let query = db.collection(collectionId).whereField(FieldPath(["base", field]), arrayContains: id)
        return await fetchItems(from: query)
    }

    // TODO: How to fix the fieldpath issue
    // Trips: Document > Base
    // Plans: Document > Base > Super
    @MainActor
    func fetchItems(field: String, isEqualTo id: String) async -> (items: [FirebaseAdaptedData], errorMessage: String) {
        // added super for testing plans. will not work with trips
        let query = db.collection(collectionId).whereField(FieldPath(["base", "super", field]), isEqualTo: id)
        return await fetchItems(from: query)
    }

    @MainActor
    private func fetchItems(from query: Query) async -> (items: [FirebaseAdaptedData], errorMessage: String) {
        guard Auth.auth().currentUser != nil else {
            return ([], Constants.messageUserNotLoggedIn)
        }

        do {
            let documents = try await query.getDocuments().documents
            let items = documents.compactMap({ try? $0.data(as: AnyFirebaseAdaptedData.self) }).map { $0.base }

            print("[FirebasePersistenceManager] Fetched: \(query)")

            return (items, "")
        } catch {
            let errorMessage = "[FirebasePersistenceManager] Error fetching: \(error)"
            return ([], errorMessage)
        }
    }

    @MainActor
    func deleteItem(id: String) async -> (hasDeletedItem: Bool, errorMessage: String) {
        guard Auth.auth().currentUser != nil else {
            return (false, Constants.messageUserNotLoggedIn)
        }

        do {
            let deletedItemRef = db.collection(collectionId).document(id)
            try await deletedItemRef.delete()

            print("[FirebasePersistenceManager] Deleted \(FirebaseAdaptedData.self): \(deletedItemRef)")

            return (true, "")
        } catch {
            let errorMessage = "[FirebasePersistenceManager] Error deleting: \(error)"
            return (false, errorMessage)
        }
    }

    @MainActor
    func updateItem<T: FirebaseAdaptedData>(id: String, item: T) async -> (hasUpdatedItem: Bool, errorMessage: String) {
        let (hasAddedItem, errorMessage) = await addItem(id: id, item: item)
        return (hasAddedItem, errorMessage)
    }
}