//
//  MovieDetailVC.swift
//  MovieDBFawaz
//
//  Created by Mohammed  Hijas on 7/24/18.
//  Copyright © 2018 Fawaz @ Boopin. All rights reserved.
//

import UIKit
import Kingfisher

class MovieDetailVC: UIViewController {
    
    @IBOutlet weak var backDropImage: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieOverview: UITextView!
    
    var rcvdBackdrop:String = ""
    var rcvdOverView:String = ""
    var rcvdMovieTitle:String = ""
   
    override func viewDidLoad() {
        super.viewDidLoad()
        print("backdrop url\(rcvdBackdrop)")
        self.updateUI()
       
    }
    
    func updateUI(){
      
    //    guard let movie = movie, let url = URL(string: "https://image.tmdb.org/t/p/w500\(movie.backdrop)")  else { return }
        let url = URL(string: "https://image.tmdb.org/t/p/w500\(rcvdBackdrop)")
        let resource = ImageResource(downloadURL: url!, cacheKey: rcvdMovieTitle)
        backDropImage.kf.setImage(with: resource, placeholder: #imageLiteral(resourceName: "placeholder"), options: [.transition(.fade(0.3))])
        movieTitle.text = rcvdMovieTitle
        movieOverview.text = rcvdOverView
       // releaseDateLabel.text = "Release Date: \(DF.format(date: movie.releaseDate))"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

   

}
