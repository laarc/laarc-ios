//
//  LIOTopStoryDetailViewController.swift
//  LaarcIOS
//
//  Created by Emily Kolar on 1/18/19.
//  Copyright © 2019 Emily Kolar. All rights reserved.
//

import UIKit

class LIOTopStoryDetailViewController: UIViewController {
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var openButton: UIBarButtonItem!
    @IBOutlet weak var titleItem: UINavigationItem!
    @IBOutlet weak var tableView: UITableView!
    
    var item: LIOItem!
    var number: Int!

    var topLevelComments = [LIOItem]()
    var commentCellItems = [CommentCellItem]()

    @objc func goBack() {
        navigationController?.popViewController(animated: true)
    }

    @objc func openURL() {
        let url = item?.url;
        if (url != nil) {
            let u = URL.init(string: url!);
            if (u != nil && url! != "about:blank") {
                UIApplication.shared.open(u!);
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        doneButton.action = #selector(goBack)
        openButton.action = #selector(openURL)

        tableView.delegate = self
        tableView.dataSource = self

        loadItemKids()
    }

    func renderComments() {
       tableView.reloadData()
    }

    func loadKid(kidId: Int, index: Int) {
        LIOApi.shared.getItem(id: kidId) { kidData in
            if let kd = kidData as? [String: Any] {
                let kidItem = LIOItem(item: kd)
                if kidItem.type == .comment {
                    let cellItem = CommentCellItem.init()
                    cellItem.item = kidItem
                    self.commentCellItems.append(cellItem)
                }
            }
            if let kids = self.item.kids, kids.count > index + 1 {
                self.loadKid(kidId: kids[index + 1], index: index + 1)
            } else {
                self.renderComments()
            }
        }
    }

    func loadItemKids() {
        if let kids = item.kids, kids.count > 0 {
            loadKid(kidId: kids[0], index: 0)
        }
    }
    
    @objc func infoLabelPressed() {
        
    }

    @objc func addCommentPressed(_ sender: Any) {
        let addCommentVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "addCommentVC") as! LIOAddCommentViewController
        addCommentVC.item = item
        navigationController?.pushViewController(addCommentVC, animated: true)
    }
    
    @IBAction func upvotePressed(_ sender: Any) {
    }
    
    @IBAction func downvotePressed(_ sender: Any) {
    }
}

extension LIOTopStoryDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if commentCellItems[indexPath.row].isExpanded {
            return UITableView.automaticDimension
        }
        return 110
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 160
    }
}

extension LIOTopStoryDetailViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentCellItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = LIOCommentTableViewCell.instanceFromNib(item: commentCellItems[indexPath.row].item, isExpanded: commentCellItems[indexPath.row].isExpanded)
        cell.updateLabel(isExpanded: commentCellItems[indexPath.row].isExpanded)
        cell.setDelegate(del: self)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let commentCellItem = commentCellItems[indexPath.row]
        commentCellItem.toggleExpanded()
        tableView.reloadRows(at: [indexPath], with: .none)
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = LIOStoryDetailTableHeader.instanceFromNib(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 110), item: item)
        headerView.addCommentButton.addTarget(self, action: #selector(addCommentPressed(_:)), for: .touchUpInside)
        return headerView
    }
    
}

extension LIOTopStoryDetailViewController: ReplyDelegate {
    func addReply(item: LIOItem) {
        let addCommentVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "addCommentVC") as! LIOAddCommentViewController
        addCommentVC.item = item
        navigationController?.pushViewController(addCommentVC, animated: true)
    }
}
