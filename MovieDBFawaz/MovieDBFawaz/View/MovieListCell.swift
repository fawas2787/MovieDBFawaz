//
//  MovieListCell.swift
//  MovieDBFawaz
//
//  Created by Mohammed  Fawaz on 7/23/18.
//  Copyright © 2018 Fawaz @ Boopin. All rights reserved.
//

import UIKit
import Kingfisher

class MovieListCell: UITableViewCell {

    // Property -- Outlets
    @IBOutlet weak var movieNameLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var overViewTextView: UITextView!
    @IBOutlet weak var moviePosterImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    var movie: Movie? {
        didSet {
            self.updateUI()
        }
    }
    
    private  func updateUI(){
        guard let movie = movie, let url = URL(string: "https://image.tmdb.org/t/p/w92\(movie.posterPath)")  else { return }
        let resource = ImageResource(downloadURL: url, cacheKey: movie.title)
        moviePosterImg.kf.setImage(with: resource, placeholder: #imageLiteral(resourceName: "placeholder"), options: [.transition(.fade(0.3))])
        movieNameLabel.text = movie.title
        overViewTextView.text = movie.overview
        releaseDateLabel.text = "Release Date: \(DF.format(date: movie.releaseDate))"
    }
   
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
