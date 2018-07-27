//
//  MovieAPI.swift
//  MovieDBFawaz
//
//  Created by Mohammed  Fawaz on 7/23/18.
//  Copyright © 2018 Fawaz @ Boopin. All rights reserved.
//

import Foundation
import Moya

enum MovieApi
{
    case suggestedMovies(id:Int)
    case newMovies(page:Int)
   
}

extension MovieApi: TargetType
{
    // set content type of the header
    var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }
    
    // Set the Base URL
    var baseURL: URL {
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/") else { fatalError("baseURL could not be configured") }
        return url
    }
    
    // Define the path or directories
    var path: String {
        switch self {
        case .suggestedMovies(let id):
            return "\(id)/suggestions"
        case .newMovies:
            return "now_playing"
        
        
        }
    }
    
  
    // Set Methods
    var method: Moya.Method {
        switch self {
        case  .newMovies, .suggestedMovies:
            return .get
        
        }
    }
    
    // set Initial Parameters for each routes
    var parameters: [String : Any]? {
        switch self {
        case .suggestedMovies:
            return ["api_key": API.apiKey]
        case .newMovies(let page):
            return ["page": page, "api_key": API.apiKey]
        
        }
    }
    
    // Parameter encoding
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .suggestedMovies, .newMovies:
            return URLEncoding.queryString
       
        }
    }
    
    // Finally request task
    var task: Task {
        switch self {
        case .suggestedMovies:
            return .requestPlain
            
        case .newMovies(let page):
            return .requestParameters(parameters:  ["page":page, "api_key":API.apiKey], encoding: URLEncoding.queryString)
        
        }
    }
    
}

