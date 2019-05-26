//
//  SearchResult.swift
//  OpenLibrary
//
//  Created by Remar Supnet on 5/23/19.
//  Copyright © 2019 Remar Supnet. All rights reserved.
//

import UIKit
import SwiftyJSON

class SearchResult {

    let start : Int
    let numFound : Int
    var results : [DocItem]
    
    init(json : JSON) {
        start = json["start"].intValue
        numFound = json["numFound"].intValue
        results = json["docs"].arrayValue.map { DocItem(json: $0) }
    }
    
    func addPreviousEntries(previousResults : [DocItem]) {
        results.insert(contentsOf: previousResults, at: 0)
    }
    
}
