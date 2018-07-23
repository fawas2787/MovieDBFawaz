//
//  MovieListVC.swift
//  MovieDBFawaz
//
//  Created by Mohammed  Hijas on 7/23/18.
//  Copyright © 2018 Fawaz @ Boopin. All rights reserved.
//

import UIKit
import Moya
class MovieListVC: UIViewController {

    // *** -- Property Outlets -- *** \\
    
    @IBOutlet weak var tableView: UITableView!
    
    var nowPlayingMovies: [Movie]!
    var suggestedMovies: [Movie]!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

  // Access the getNewMMovies
    
    func getMovies()
    {
        API.getNewMovies(page: 1, completion: {movies in
            self.nowPlayingMovies = movies
            print("New Movies: \(self.nowPlayingMovies)")
            self.tableView.reloadData()
        })
    }

}
