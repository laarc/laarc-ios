//
//  CommentsViewController.swift
//  LaarcIOS
//
//  Created by Emily Kolar on 1/22/19.
//  Copyright © 2019 Emily Kolar. All rights reserved.
//

import UIKit

class CommentsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    var expandedLabel: UILabel!
    var indexOfCellToExpand: Int!

    var movies: [[String: AnyObject]]!
    var selectedMovie: [String: AnyObject]!
    var selectedMoviePhoto: UIImage!

    override func viewDidLoad() {
        super.viewDidLoad()
        super.viewDidLoad()
        indexOfCellToExpand = -1
        tableView.dataSource = self
        tableView.delegate = self
        movies = [[String: AnyObject]]()
        let url = URL(string: "http://sweettutos.com/movies.json")
        let task = URLSession.shared.dataTask(with: url!) { data, resp, err in
            if err == nil
            {
                do {
                    let results = try JSONSerialization.jsonObject(with: data!, options: .mutableLeaves) as! [String:AnyObject]
                    self.movies = results["movies"] as? [[String: AnyObject]]
                    DispatchQueue.main.async(execute: {
                        self.tableView.reloadData()
                    })
                }catch
                {
                    print("An error occurred")
                }
            }
        }
        task.resume()
    }
    

    @objc func expandCell(_ sender: UITapGestureRecognizer) {
        let label = sender.view as! UILabel
        let cell = tableView.cellForRow(at: IndexPath(row: label.tag, section: 0)) as! CommentTableCell
        let movie = self.movies[label.tag]
        let description = movie["Description"] as! String
        cell.movieDescription.sizeToFit()
        cell.movieDescription.text = description
        expandedLabel = cell.movieDescription
        indexOfCellToExpand = label.tag
        tableView.reloadRows(at: [IndexPath(row: label.tag, section: 0)], with: .fade)
        tableView.scrollToRow(at: IndexPath(row: label.tag, section: 0), at: .top, animated: true)
    }
}

extension CommentsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellID") as! CommentTableCell
        let movie = self.movies[indexPath.row]
        let photoURL = movie["Photo"] as! String
        let title = movie["Title"] as! String
        let intro = movie["Intro"] as! String
        cell.movieTitle.text = title
        cell.movieDescription.text = intro
        cell.movieDescription.tag = indexPath.row
        let tap = UITapGestureRecognizer(target: self, action: #selector(expandCell(_:)))
        cell.movieDescription.addGestureRecognizer(tap)
        cell.movieDescription.isUserInteractionEnabled = true
        // Download the photo using the SDWebImage library
//        cell.moviePhoto.sd_setImage(with: URL(string: photoURL))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == indexOfCellToExpand
        {
            return 170 + expandedLabel.frame.height - 38
        }
        return 170
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedMovie = movies[indexPath.row]
        let cell = tableView.cellForRow(at: indexPath) as! CommentTableCell
        selectedMoviePhoto = cell.moviePhoto.image
        self.performSegue(withIdentifier: "ShowDetails", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let detailsVC = segue.destination as! DetailsViewController
//        detailsVC.movie = selectedMovie
//        detailsVC.photo = selectedMoviePhoto
    }
}
