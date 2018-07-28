//
//  MovieListVC.swift
//  MovieDBFawaz
//
//  Created by Mohammed  Fawaz on 7/23/18.
//  Copyright © 2018 Fawaz @ Boopin. All rights reserved.
//

import UIKit
import Moya
import Kingfisher
class MovieListVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var txtSearchBar: UITextField!
    @IBOutlet weak var popMoviesList: UIView!
   
    var nowPlayingMovies: [Movie] = []
    var suggestedMovies: [Movie]!
    var filteredMovies = [Movie]()
    var searchedKeyArray = [String]()
    var searchHistoryArray = [String]()
    
    var movie: Movie?
    var slctdBackdrop:String = ""
    var slctdMovieTitle:String = ""
    var slctdOverView:String = ""
    var slctdReleaseDate:String = ""
    var url:String = ""
    var isSearching: Bool = false
    var isSearchFocused: Bool = false
    var lastPageRetrieved: Int = 0
    var reachedEndofItems = false
    var searchKeyword: String = ""
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Start Loading Movie API (Latest Movies) from Any Page you like
        self.getMovies(page: 1)
        popMoviesList.isHidden = true
        
        
    }

    // Load more data of the Next Page when the last item of the particular page reached
    func loadMore()
    {
        //get the page number
        var nextPage: Int = 1
        if lastPageRetrieved > 0
        {
            //Append the Page Number According to last Page
            nextPage += lastPageRetrieved
        }
        getMovies(page: nextPage)
    }
    // Call the new movies API according to the page no
    func getMovies(page: Int) {
        API.getNewMovies(page: page, completion: {movies in
            
            
           // Append the new movies to the data source
            self.nowPlayingMovies += movies
            
            // Record the last page you retrieved
            self.lastPageRetrieved = page
            print("last Page: \(self.lastPageRetrieved)")
            
            self.tableView.reloadData()
        })
    }

    // *** -- TableView Delegate -- *** \\
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        /*
        if nowPlayingMovies == nil {
            return 0
        }
        */
        if isSearching
        {
            if (filteredMovies.count == 0)
            {
                // create the alert
                let alert = UIAlertController(title: "Info", message: "No Search Results Found!", preferredStyle: UIAlertControllerStyle.alert)
                
                // add an action (button)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                
                // show the alert
                self.present(alert, animated: true, completion: nil)
            }
            return filteredMovies.count
        }
        else
        {
        return nowPlayingMovies.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieListCell", for: indexPath) as! MovieListCell
        
        if isSearching
        {
            cell.movie = filteredMovies[indexPath.row]
        }
        else
        {
            cell.movie = nowPlayingMovies[indexPath.row]
        }
        
        return cell
    }
    
    // tableView Selection
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         if isSearching
        {
            
            let selectedMovie = filteredMovies[indexPath.row]
            if selectedMovie.backdrop != nil {
                slctdBackdrop = selectedMovie.backdrop!
            }
            else
            {
                slctdBackdrop = "NotFound"
            }
            
            
            slctdOverView = selectedMovie.overview
            slctdMovieTitle = selectedMovie.title
            slctdReleaseDate = selectedMovie.releaseDate
        }
        else
        {
            let selectedMovie = nowPlayingMovies[indexPath.row]
             if selectedMovie.backdrop != nil {
            slctdBackdrop = selectedMovie.backdrop!
            }
            else
             {
                slctdBackdrop = "NotFound"
            }
            slctdOverView = selectedMovie.overview
            slctdMovieTitle = selectedMovie.title
            slctdReleaseDate = selectedMovie.releaseDate
        }
        
        performSegue(withIdentifier: "DetailSegue", sender: self)
        
    }
    
    // set custom hieght to the Movie List Cell
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 147.0;//Choose your custom row height
    }
    
    // display more data
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // Check if the last row number is the same as the last current data element
        if indexPath.row == self.nowPlayingMovies.count - 1 {
            if !reachedEndofItems
            {
                 self.loadMore()
            }
           
        }
    }
    
    //** - UITextView Delegates
    // When search key pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text == nil || textField.text == ""
        {
            // When no strings in search field then searching is disabled.
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
            // save all search keys into User Defaults
            UserDefaults.standard.set(txtSearchBar.text, forKey: "searchKey")
            searchKeyword = txtSearchBar.text!
            
            searchedKeyArray.append(searchKeyword)
                UserDefaults.standard.set(searchedKeyArray, forKey: "searchArrayKey")
            print("search Keywords Array", searchedKeyArray)
            
            //Filtering the New Movies According to the Movie Title
            filteredMovies = nowPlayingMovies.filter { $0.title.localizedCaseInsensitiveContains(query) }
            tableView.reloadData()
        }
        
        self.resignFirstResponder()
        self.view.endEditing(true)
        
        return true
    }
    func searchFocusLost()
    {
        isSearchFocused = false
        // Animate the popup search list when hiding
        UIView.animate(withDuration: 0.3, animations: {
            self.popMoviesList.alpha = 0
        }, completion:  {
            (value: Bool) in
            self.popMoviesList.isHidden = true
        })
    }
    
    //when search textfield focused
    func textFieldDidBeginEditing(_ textField: UITextField) {
        isSearchFocused = true
        // Animate the popup search list when showing
        self.popMoviesList.isHidden = false
        UIView.animate(withDuration: 0.3, animations: {
            self.popMoviesList.alpha = 1
        }, completion:  nil)
        
        searchHistoryArray = UserDefaults.standard.stringArray(forKey: "searchArrayKey") ?? [String]()
        print("Search History Array:\(searchHistoryArray)")
            print("Text Field Focused")
    }
    
    //when search textfield lost focused
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        self.searchFocusLost()
        print("Text Field Focuse Lost")
    }
  
    //Segue Method
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if (segue.identifier == "DetailSegue")
        {
            let destination = segue.destination as! MovieDetailVC
            destination.rcvdBackdrop = slctdBackdrop
            destination.rcvdMovieTitle = slctdMovieTitle
            destination.rcvdOverView = slctdOverView
            destination.rcvdReleaseDate = slctdReleaseDate
            
        }
    }
}



