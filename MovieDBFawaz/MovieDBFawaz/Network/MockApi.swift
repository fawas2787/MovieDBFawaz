//
//  MockApi.swift
//  MovieDBFawaz
//
//  Created by Mohammed  Hijas on 7/23/18.
//  Copyright © 2018 Fawaz @ Boopin. All rights reserved.
//

import Foundation

extension MovieApi {
    var sampleData: Data {
        switch self {
        case .suggestedMovies, .newMovies:
            return stubbedResponse("Movies")
        }
    }
    
    func stubbedResponse(_ filename: String) -> Data! {
        guard let path = Bundle.main.path(forResource: filename, ofType: "json") else { fatalError("path could not be found") }
        return (try? Data(contentsOf: URL(fileURLWithPath: path)))
}
}
