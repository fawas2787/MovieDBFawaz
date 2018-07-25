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
class MovieListVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var txtSearchBar: UITextField!
    
    
    var nowPlayingMovies: [Movie]!
    var suggestedMovies: [Movie]!
    var filteredMovies = [Movie]()
    
    var movie: Movie?
    var slctdBackdrop:String = ""
    var slctdMovieTitle:String = ""
    var slctdOverView:String = ""
    var url:String = ""
    var isSearching: Bool = false
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        self.getMovies()
       
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

  // Access the getNewMMovies
    
    func getMovies()
    {
        API.getNewMovies(page: 1, completion: {movies in
            self.nowPlayingMovies = movies
            self.tableView.reloadData()
        })
    }
    
    // Custom Search Function
    
    
    
    // *** -- TableView Delegate -- *** \\
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if nowPlayingMovies == nil {
            return 0
        }
        return nowPlayingMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieListCell", for: indexPath) as! MovieListCell
        
        cell.movie = nowPlayingMovies![indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "DetailVC") as! MovieDetailVC
        
        let selectedMovie = nowPlayingMovies[indexPath.row]
        slctdBackdrop = selectedMovie.backdrop
        slctdOverView = selectedMovie.overview
        slctdMovieTitle = selectedMovie.title
        
        performSegue(withIdentifier: "DetailSegue", sender: self)
        
        self.present(detailVC, animated: true, completion: nil)
     
        
    }
    
    // set custom hieght to the Movie List Cell
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 147.0;//Choose your custom row height
    }
    
    //** - UITextView Delegates
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text == nil || textField.text == ""
        {
            isSearching = false
            tableView.reloadData()
            view.endEditing(true)
            view.resignFirstResponder()
        }
        else
        {
            isSearching = true
            guard let query = textField.text?.trimmingCharacters(in: .whitespaces) else
            {
                fatalError("no query string")
            }
            
            //assiginig searching from new movies
            filteredMovies = nowPlayingMovies.filter { $0.title.localizedCaseInsensitiveContains(query) }
            tableView.reloadData()
        }
        
        self.resignFirstResponder()
        self.view.endEditing(true)
        
        return true
    }
    
    // segue Method
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        
        if (segue.identifier == "DetailSegue")
        {
            let destination = segue.destination as! MovieDetailVC
            destination.rcvdBackdrop = slctdBackdrop
            destination.rcvdMovieTitle = slctdMovieTitle
            destination.rcvdOverView = slctdOverView
            
        }
    }
    
    
    

}


