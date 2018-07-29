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
    @IBOutlet weak var tableViewSuggested: UITableView!
    @IBOutlet weak var txtSearchBar: UITextField!
    @IBOutlet weak var popMoviesList: UIView!
   
    var nowPlayingMovies: [Movie] = []
    var filteredMovies = [Movie]()
    var searchedKeyArray = [String]()
    var searchHistoryArray = [String]()
    var recentResultsArray = [String]()
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
    var searchResults:String = ""
    
   
    
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
      
        //suggested search tableview delegates
        if tableView == self.tableViewSuggested
        {
            return searchHistoryArray.count
        }
        
        // movie list search tableview delegates
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
        
        if tableView == self.tableViewSuggested
        {
            let sCell = tableView.dequeueReusableCell(withIdentifier: "SearchListCell", for: indexPath) as! SearchListCell
            
            sCell.keywordLabel.text = searchHistoryArray[indexPath.row]
            
            return sCell
        }
        
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
         // select the recent searched keywords
         if tableView == self.tableViewSuggested
         {
            txtSearchBar.text = searchHistoryArray[indexPath.row]
         }
        else
         {
            
           if isSearching
        {
            // select and pass the values of current searched keyword
            let selectedMovie = filteredMovies[indexPath.row]
            //handling the backdrop path nil error
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
            //select and pass all the latest movies
            let selectedMovie = nowPlayingMovies[indexPath.row]
            //handling the backdrop path nil error
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
        // navigate to detail view
        performSegue(withIdentifier: "DetailSegue", sender: self)
        }
    }
    
    // set custom hieght to the Movie List Cell
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if tableView == self.tableViewSuggested
        {
            return 44.0  // set the recent search height
        }
        return 147.0; //set the Movie List Table height
    }
    
    // display more data
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // Check if the last row number is the same as the last current data element
        if indexPath.row == self.nowPlayingMovies.count - 1 {
            if !reachedEndofItems
            {
                 self.loadMore() // load more data of the next page when the last element of the current page reached
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
            // when search is active.
            isSearching = true
            guard let query = textField.text?.trimmingCharacters(in: .whitespaces) else
            {
                fatalError("no query string")
            }
            //Filtering the New Movies According to the Movie Title
            filteredMovies = nowPlayingMovies.filter { $0.title.localizedCaseInsensitiveContains(query) }
            tableView.reloadData()
            // if there are no previouse search keywords
            if searchHistoryArray.count == 0
            {
                // exclude the searchkeywords when there were no results returned
                if filteredMovies.count == 0
                {
                    print("No Results for the searched keyword")
                }
                else
                {
                    // save all search keys into User Defaults
                    UserDefaults.standard.set(txtSearchBar.text, forKey: "searchKey")
                    // store the search box inputs into the searchKeyword variable
                    searchKeyword = txtSearchBar.text!
                    //append the searched keywords into an array
                    searchedKeyArray.append(searchKeyword)
                    // save the array into userdefaults
                    UserDefaults.standard.set(searchedKeyArray, forKey: "searchArrayKey")
                    print("search Keywords Array", searchedKeyArray)
                }
           
            }
           // if there are no previouse search keywords
            else
            {
                searchHistoryArray.removeAll()
                // retrieve the previouse searches array
                searchHistoryArray = UserDefaults.standard.stringArray(forKey: "searchArrayKey") ?? [String]()
                
              //  UserDefaults.standard.set(txtSearchBar.text, forKey: "searchKey")
                
                if filteredMovies.count == 0
                {
                     print("No Results for the searched keyword")
                }
                else
                {
                     searchKeyword = txtSearchBar.text!
                     //appende the search keywords
                     searchedKeyArray.append(searchKeyword)
                     //then join both arrays
                     searchedKeyArray.append(contentsOf: searchHistoryArray)
               
                     // remove the duplicates, if any
                     let uniqueValues = Array(Set(searchedKeyArray))
                     //save the array into user defaults
                     UserDefaults.standard.set(uniqueValues, forKey: "searchArrayKey")
                     print("recent results Array", uniqueValues)
                }
                
            }
            
           
        }
        
        self.resignFirstResponder()
        self.view.endEditing(true)
        
        return true
    }
    // when search focus lost
    func searchFocusLost()
    {
        isSearchFocused = false
       // searchedKeyArray.removeAll()
        searchHistoryArray.removeAll()
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
        // retriving recent array from user defaults
       searchHistoryArray = UserDefaults.standard.stringArray(forKey: "searchArrayKey") ?? [String]()
        //get the last 10 records from array
       searchHistoryArray = Array(searchHistoryArray.suffix(10))
        // sort descending
        
        self.tableViewSuggested.reloadData()
        
    }
    
    //when search textfield lost focused
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        self.searchFocusLost()
        
    }
  
    //Segue Method
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        //perform segue and send data to the detail view
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



