//
//  CommentsViewController.swift
//  LaarcIOS
//
//  Created by Emily Kolar on 1/22/19.
//  Copyright © 2019 Emily Kolar. All rights reserved.
//

import UIKit

public let BIRD_GREEN = UIColor(red: 102/255, green: 170/255, blue: 170/255, alpha: 1.0)

class CommentsViewController: UIViewController {
    @IBOutlet weak var actionsView: UIView!
    @IBOutlet weak var tableView: UITableView!

    var expandedLabel: UILabel?
    var indexOfCellToExpand: Int!
    
    var items = [LIOItem]()
    var itemIds = [Int]()
    var selectedItem: LIOItem?

    var isRefreshing = false
    var itemsPerPage = 30

    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: .valueChanged)
        refreshControl.tintColor = BIRD_GREEN
        return refreshControl
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        super.viewDidLoad()
        indexOfCellToExpand = -1
        setupTable()
        loadTopStoryIds(loadStoriesAfter: true)
    }
    
    func setupTable() {
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: .valueChanged)
        refreshControl.tintColor = BIRD_GREEN
        tableView.delegate = self
        tableView.dataSource = self
        tableView.addSubview(refreshControl)
    }

    @objc func handleRefresh(_ sender: Any) {
        isRefreshing = true
//        loadedTopStoryItems.removeAll()
//        loadTopStoryIds(loadStoriesAfter: true)
    }

    @objc func expandCell(_ sender: UITapGestureRecognizer) {
        let label = sender.view as! UILabel

        if label.tag == indexOfCellToExpand {
            indexOfCellToExpand = -1
            expandedLabel = nil
        } else {
            let cell = tableView.cellForRow(at: IndexPath(row: label.tag, section: 0)) as! CommentTableCell
            cell.commentLabel.sizeToFit()
            cell.commentLabel.text = description
            expandedLabel = cell.commentLabel
            indexOfCellToExpand = label.tag
        }
        tableView.reloadRows(at: [IndexPath(row: label.tag, section: 0)], with: .fade)
        tableView.scrollToRow(at: IndexPath(row: label.tag, section: 0), at: .top, animated: true)
    }
}

extension CommentsViewController {
    func loadTopStoryIds(loadStoriesAfter: Bool) {
        LIOApi.shared.getTopStoriesOnce() { data in
            if let storyIds = data as? [Int] {
                self.itemIds = storyIds

                if loadStoriesAfter {
                    self.loadTopStoryItems()
                }
            }
        }
    }
    
    func replaceItemsWithLoadedItems() {
//        topStoryItems.removeAll()
//        topStoryItems.append(contentsOf: loadedTopStoryItems)
        tableView.reloadData()
        if isRefreshing {
            isRefreshing = false
            refreshControl.endRefreshing()
        }
    }
    
    func handleItemLoaded(item: LIOItem) {
        if (item.title != nil) {
            items.append(item)
//            loadedTopStoryItems.append(item)
        }
    }
    
    func loadItem(id: Int, index: Int) {
        LIOApi.shared.getItem(id: id) { data in
            if let data = data as? [String: Any] {
                let item = LIOItem(item: data)
                self.handleItemLoaded(item: item)
                
                var finished = false
                
                if index < self.itemsPerPage {
                    let nextIndex = index + 1
                    if nextIndex < self.itemIds.count {
                        self.loadItem(id: self.itemIds[nextIndex], index: nextIndex)
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
        if itemIds.count > 0 {
            let startingId = itemIds[0]
            loadItem(id: startingId, index: 0)
        }
    }
    
    @objc func goBack() {
        navigationController?.popViewController(animated: true)
    }
}

extension CommentsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellID") as! CommentTableCell
        cell.item = items[indexPath.row]
        cell.commentLabel.text = ipsum
        cell.commentLabel.tag = indexPath.row
        let tap = UITapGestureRecognizer(target: self, action: #selector(expandCell(_:)))
        cell.commentLabel.addGestureRecognizer(tap)
        cell.commentLabel.isUserInteractionEnabled = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let expandedLabel = expandedLabel, indexPath.row == indexOfCellToExpand {
            return 170 + expandedLabel.frame.height - 38
        }
        return 170
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! CommentTableCell
        selectedItem = items[indexPath.row]
        self.performSegue(withIdentifier: "ShowDetails", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailsVC = segue.destination as! DetailViewController
        detailsVC.item = selectedItem
    }
}
