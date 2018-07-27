//
//  MovieDetailVC.swift
//  MovieDBFawaz
//
//  Created by Mohammed  Fawaz on 7/24/18.
//  Copyright © 2018 Fawaz @ Boopin. All rights reserved.
//

import UIKit
import Kingfisher

class MovieDetailVC: UIViewController {
    
    @IBOutlet weak var backDropImage: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieOverview: UITextView!
    @IBOutlet weak var releaseDate: UILabel!
    
    var rcvdBackdrop:String = ""
    var rcvdOverView:String = ""
    var rcvdMovieTitle:String = ""
    var rcvdReleaseDate:String = ""
   
    override func viewDidLoad() {
        super.viewDidLoad()
        print("backdrop url\(rcvdBackdrop)")
        self.updateUI()
       
    }
    
    func updateUI(){
        let url = URL(string: "https://image.tmdb.org/t/p/w500\(rcvdBackdrop)")
        let resource = ImageResource(downloadURL: url!)
        backDropImage.kf.setImage(with: resource, placeholder: #imageLiteral(resourceName: "placeholder"), options: [.transition(.fade(0.3))])
        movieTitle.text = rcvdMovieTitle
        movieOverview.text = rcvdOverView
        releaseDate.text = "Release Date: \(DF.format(date: rcvdReleaseDate))"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

   

}
