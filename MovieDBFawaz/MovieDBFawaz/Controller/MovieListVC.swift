//
//  MovieListVC.swift
//  MovieDBFawaz
//
//  Created by Mohammed  Hijas on 7/23/18.
//  Copyright © 2018 Fawaz @ Boopin. All rights reserved.
//

import UIKit
import Moya
import Kingfisher
class MovieListVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // *** -- Property Outlets -- *** \\
    
    @IBOutlet weak var tableView: UITableView!
    
    var nowPlayingMovies: [Movie]!
    var suggestedMovies: [Movie]!
    var movie: Movie?
    var url:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getMovies()
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
    
    // *** -- TableView Delegate -- *** \\
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if nowPlayingMovies == nil {
            return 0
        }
        return nowPlayingMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieListCell", for: indexPath) as! MovieListCell
       // let newMovies = nowPlayingMovies![indexPath.row]
        cell.movie = nowPlayingMovies![indexPath.row]
     
        return cell
    }
    
    // set custom hieght to the Movie List Cell
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 147.0;//Choose your custom row height
    }
    

}
