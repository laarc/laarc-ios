//
//  LaarcTopStoriesVM.swift
//  LaarcIOS
//
//  Created by Emily Kolar on 2/1/19.
//  Copyright © 2019 Emily Kolar. All rights reserved.
//

import Foundation

class LaarcTopStoriesVM {
    var stories = [LaarcStory]()
    var topStoryIds = [Int]()
    var currentPage = 1
    let itemsPerPage = 30
    var noopStoryIds = [Int]()

    func getTopStoriesData(completion: @escaping ([LaarcStory]) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            self.loadLaarcTopStoryIds() { topStoryIds in
                self.clearStoryLists()
                self.topStoryIds = topStoryIds
                self.loadTopStoryData(id: topStoryIds[0], index: 0) {
                    DispatchQueue.main.async {
                        completion(self.stories)
                    }
                }
            }
        }
    }

    func clearStoryLists() {
        self.topStoryIds.removeAll()
        self.stories.removeAll()
        self.noopStoryIds.removeAll()
    }

    func loadLaarcTopStoryIds(completion: @escaping (([Int]) -> Void)) {
        LIOApi.shared.getTopStoriesOnce() { idsData in
            if let idsData = idsData as? [Int], idsData.count > 0 {
                completion(idsData)
            } else {
                completion([])
            }
        }
    }
    
    func loadTopStoryData(
        id: Int, index: Int,
        completion: @escaping (() -> Void)
        ) {
        LIOApi.shared.getItem(id: id) { data in
            if let data = data as? [String: Any] {
                let storyItem = LaarcTopStory(commentData: data)
                let isNoop = storyItem.dead || storyItem.deleted || storyItem.title == nil || storyItem.title!.isEmpty
                
                if let kids = storyItem.kids, kids.count > 0, isNoop == false {
                    let topCommentId = kids[0]
                    LIOApi.shared.getItem(id: topCommentId) { commentData in
                        if let commentData = commentData as? [String: Any] {
                            storyItem.topCommentText = commentData["text"] as? String ?? ""
                        }
                        self.appendStoryCheckIndex(story: storyItem, index: index, completion: completion)
                    }
                } else {
                    if isNoop {
                        self.noopStoryIds.append(storyItem.id)
                    }
                    self.appendStoryCheckIndex(story: storyItem, index: index, completion: completion)
                }
            }
        }
    }
    
    func appendStoryCheckIndex(
        story: LaarcStory,
        index: Int,
        completion: @escaping (() -> Void)
        ) {
        if !noopStoryIds.contains(story.id) {
            stories.append(story)
        }
        
        let nextIdx = index + 1
        let numNoops = noopStoryIds.count
        let upperBound = ((currentPage * itemsPerPage) - 1) + numNoops
        let lastIndex = topStoryIds.count - 1
        let cutoff = min(upperBound, lastIndex)
        
        if nextIdx < cutoff {
            let nextId = self.topStoryIds[index + 1]
            self.loadTopStoryData(id: nextId, index: index + 1, completion: completion)
        } else {
            completion()
        }
    }
}
