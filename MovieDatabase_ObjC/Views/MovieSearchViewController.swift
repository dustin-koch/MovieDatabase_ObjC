//
//  MovieSearchViewController.swift
//  MovieDatabase_ObjC
//
//  Created by Dustin Koch on 5/24/19.
//  Copyright © 2019 Rabbit Hole Fashion. All rights reserved.
//

import UIKit

class MovieSearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    //MARK: - Outlets
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Properties
    var movies: [Any] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    //MARK: - View support
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // IIDOO
    }
    
    // MARK: - TableView stubs
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as? MovieTableViewCell,
              let movie = movies[indexPath.row] as? DHKMovie else { return UITableViewCell() }
        DHKMovieController.sharedInstance().fetchPoster(for: movie) { (image) in
            DispatchQueue.main.async {
                cell.moviePosterImageView.image = image
            }
        }
        cell.titleLabel.text = movie.movieTitle
        if let unwrappedRating = movie.rating,
            let unwrappedVotes = movie.votes,
            unwrappedVotes != 0 {
            let floatRating = Float(truncating: unwrappedRating)
            cell.ratingLabel.text = String(format: "Rating: %.2f - Votes: \(unwrappedVotes)", floatRating)
        } else {
            cell.ratingLabel.text = "Rating: (Movie not rated)"
        }
        cell.descriptionLabel.text = movie.movieDescription
        return cell
    }
    
    //MARK: - Searchbar functionality
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        DHKMovieController.sharedInstance().fetchMovies(withSearch: searchText) { (moviesReturn) in
            guard !moviesReturn.isEmpty else { return }
            self.movies = moviesReturn
        }
    }
    
}//END OF CLASS
