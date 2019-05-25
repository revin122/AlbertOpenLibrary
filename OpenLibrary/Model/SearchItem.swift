//
//  SearchItem.swift
//  OpenLibrary
//
//  Created by Remar Supnet on 5/23/19.
//  Copyright © 2019 Remar Supnet. All rights reserved.
//

import UIKit
import SwiftyJSON

class SearchItem {

    let isbn : [String]
    let authorName : [String]
    let goodReadsID : [String]
    let amazonID : [String]
    let authorKey : [String]
    let coverEditionKey : String
    let title : String
    let publishYear : [Int]
    let firstPublishYear : Int
    let key : String
    let publisher : [String]
    let lccn : [String]
    
    init() {
        isbn = []
        authorName = []
        goodReadsID = []
        amazonID = []
        authorKey = []
        coverEditionKey = ""
        title = ""
        publishYear = []
        firstPublishYear = 0
        key = ""
        publisher = []
        lccn = []
    }
    
    init(json : JSON) {
        
        isbn = json["isbn"].arrayValue.map { $0.stringValue }
        authorName = json["author_name"].arrayValue.map { $0.stringValue }
        goodReadsID = json["id_goodreads"].arrayValue.map { $0.stringValue }
        amazonID = json["id_amazon"].arrayValue.map { $0.stringValue }
        authorKey = json["author_key"].arrayValue.map { $0.stringValue }
        coverEditionKey = json["cover_edition_key"].stringValue
        title = json["title"].stringValue
        publishYear = json["publish_year"].arrayValue.map { $0.intValue }
        firstPublishYear = json["first_publish_year"].intValue
        key = json["key"].stringValue
        publisher = json["publisher"].arrayValue.map { $0.stringValue }
        lccn = json["lccn"].arrayValue.map { $0.stringValue }
    }
    
    
    
}
