//
//  MovieDetailViewController.swift
//  MovieDatabase_ObjC
//
//  Created by Dustin Koch on 5/24/19.
//  Copyright © 2019 Rabbit Hole Fashion. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var moviePosterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    
    //MARK: - Landing pad property
    var movie: DHKMovie? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
    }
    
    //MARK: - Helper function to update views
    func updateView() {
        guard let movie = self.movie,
        let unwrappedRating = movie.rating,
        let unwrappedVotes = movie.votes else { return }
        titleLabel.text = movie.movieTitle
        ratingLabel.text = (movie.rating == 0) ? "Movie not rated" : "Rating: \(unwrappedRating) with \(unwrappedVotes) votes"
        summaryLabel.text = (movie.movieDescription == "") ? "No summary available" : movie.movieDescription
        DHKMovieController.sharedInstance().fetchPoster(for: movie) { (image) in
            DispatchQueue.main.async {
                self.moviePosterImageView.image = image
                if self.moviePosterImageView.image == nil {
                    self.moviePosterImageView.image = UIImage(named: "noimage")
                }
            }
        }
    }

}//END OF CLASS
