//
//  LIOTopStoriesViewController.swift
//  LaarcIOS
//
//  Created by Emily Kolar on 1/17/19.
//  Copyright © 2019 Emily Kolar. All rights reserved.
//

import UIKit

//let BIRD_GREEN = UIColor(red: 102/255, green: 170/255, blue: 170/255, alpha: 1.0)

class LIOTopStoriesViewController: UITableViewController {

    var topStoryIds = [Int]()
    var topStoryItems = [LIOItem]()
    var loadedTopStoryItems = [LIOItem]()
    var lastLoadedIndex = -1
    var itemsPerPage = 30
    var isRefreshing = false

//    lazy var refreshControl: UIRefreshControl = {
//        let refreshControl = UIRefreshControl()
//        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: .valueChanged)
//        refreshControl.tintColor = BIRD_GREEN
//        return refreshControl
//    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTable()
        loadTopStoryIds(loadStoriesAfter: true)
        // Do any additional setup after loading the view.
    }

    func setupTable() {
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(handleRefresh(_:)), for: .valueChanged)
        refreshControl?.tintColor = BIRD_GREEN
        tableView.delegate = self
        tableView.dataSource = self
        tableView.addSubview(refreshControl!)
    }

    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        isRefreshing = true
        loadedTopStoryItems.removeAll()
        loadTopStoryIds(loadStoriesAfter: true)
    }

}

extension LIOTopStoriesViewController {
    func loadTopStoryIds(loadStoriesAfter: Bool) {
        LIOApi.shared.getTopStoriesOnce() { data in
            if let storyIds = data as? [Int] {
                self.topStoryIds = storyIds

                if loadStoriesAfter {
                    self.loadTopStoryItems()
                }
            }
        }
    }

    func replaceItemsWithLoadedItems() {
        topStoryItems.removeAll()
        topStoryItems.append(contentsOf: loadedTopStoryItems)
        tableView.reloadData()
        if isRefreshing {
            isRefreshing = false
            refreshControl?.endRefreshing()
        }
    }

    func handleItemLoaded(item: LIOItem) {
        if (item.title != nil) {
            loadedTopStoryItems.append(item)
        }
    }

    func loadItem(id: Int, index: Int) {
        LIOApi.shared.getItem(id: id) { data in
            if let data = data as? [String: Any] {
                let item = LIOItem(item: data)
                self.handleItemLoaded(item: item)

                var finished = false

                if index < (self.lastLoadedIndex + self.itemsPerPage) - 1 {
                    let nextIndex = index + 1

                    if nextIndex < self.topStoryIds.count - 1 {
                        self.loadItem(id: self.topStoryIds[nextIndex], index: nextIndex)
                    } else {
                        finished = true
                    }
                } else {
                   finished = true
                }
                
                if finished {
                    self.replaceItemsWithLoadedItems()
                }
            }
        }
    }

    func loadTopStoryItems() {
        let startingIndex = lastLoadedIndex + 1

        if startingIndex < topStoryIds.count - 1 {
            let startingId = topStoryIds[startingIndex]
            loadItem(id: startingId, index: startingIndex)
        }
    }
}

extension LIOTopStoriesViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topStoryItems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "topStoryCell") as! LIOTopStoryTableViewCell
        cell.configure(item: topStoryItems[indexPath.row], number: indexPath.row + 1)
        return cell
    }
}

extension LIOTopStoriesViewController {
    @objc func goBack() {
        navigationController?.popViewController(animated: true)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "topStoryDetailVC") as! LIOTopStoryDetailViewController
        let item = topStoryItems[indexPath.row]
        detailVC.item = item
        detailVC.number = indexPath.row + 1
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
