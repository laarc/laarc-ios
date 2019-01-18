//
//  LIOApi.swift
//  LaarcIOS
//
//  Created by Emily Kolar on 1/17/19.
//  Copyright © 2019 Emily Kolar. All rights reserved.
//

import Foundation
import FirebaseDatabase

class LIOApi {
    static let shared = LIOApi()

    private let db: DatabaseReference!

    var topStoriesDelegate: TopStoriesDelegate?

    // MARK: - Init

    private init() {
        db = Database.database().reference(withPath: LIO_API_VERSION)
        watchTopStories()
    }

    // MARK: - Private methods

    private func handleTopStories(snapshot: DataSnapshot) {
        if let storyIds = snapshot.value as? [Any] {
            self.topStoriesDelegate?.didUpdateTopStoryIds(storyIds)
        }
    }

    private func watchTopStories() {
        db.child(ENDPOINT_TOP_STORIES).observe(.value) { snapshot in
            self.handleTopStories(snapshot: snapshot)
        }
    }

    // MARK: - Public methods

    func getTopStoriesOnce(completion: @escaping (Any?) -> Void) {
        db.child(ENDPOINT_TOP_STORIES).observeSingleEvent(of: .value) { snapshot in
            let value = snapshot.value
            completion(value)
        }
    }

    func getItem(id: Int, completion: @escaping (Any?) -> Void) {
        db.child(ENDPOINT_ITEM).child(String(id)).observe(.value) { snapshot in
            let value = snapshot.value
            completion(value)
        }
    }
}

protocol TopStoriesDelegate {
    func didUpdateTopStoryIds(_ storyIds: [Any])
}
