//
//  DateFormatter.swift
//  MovieDBFawaz
//
//  Created by Mohammed  Fawaz on 7/24/18.
//  Copyright © 2018 Fawaz @ Boopin. All rights reserved.
//

import Foundation


class DF {
    static let instance = DateFormatter()
    
    static func format(date: String) -> String {
        instance.dateFormat = "yyyy-MM-dd"
        guard let date = instance.date(from: date) else { fatalError("could not format date") }
        instance.dateFormat = "MMM dd yyyy"
        return instance.string(from: date)
    }
}
