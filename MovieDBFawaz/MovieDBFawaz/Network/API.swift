//
//  API.swift
//  MovieDBFawaz
//
//  Created by Mohammed  Hijas on 7/23/18.
//  Copyright © 2018 Fawaz @ Boopin. All rights reserved.
//

import Foundation
import Moya

class API
{
    // This "THEMOVIEDB" api Key registered under - fawasfais@gmail.com
    static let apiKey = "54f021c6cab370658d7b5b7417ac1bd9"
   
    static let provider = MoyaProvider<MovieApi>(plugins: [NetworkLoggerPlugin(verbose: true)])
    
    // Get new movies method to show new movies on the movielistVC
    static func getNewMovies(page: Int, completion: @escaping ([Movie])->()){
        
        provider.request(.newMovies(page: page)) { result in
            
            switch result {
            case let .success(response):
                do {
                    let results = try JSONDecoder().decode(APIResults.self, from: response.data)
                    completion(results.movies)
                }catch let err{
                    print(err)
                }
            case let .failure(error):
                print(error)
            }
        }
    }
}
