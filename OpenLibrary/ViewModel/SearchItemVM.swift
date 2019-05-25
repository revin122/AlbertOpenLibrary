//
//  SearchItemVM.swift
//  OpenLibrary
//
//  Created by Remar Supnet on 5/23/19.
//  Copyright © 2019 Remar Supnet. All rights reserved.
//

import UIKit

class SearchItemVM {
    
    enum ImageSize : Character {
        case small = "S"
        case medium = "M"
    }
    
    let title : String
    let subtitle : String
    
    private var searchItem : SearchItem
    
    init() {
        title = ""
        subtitle = ""
        searchItem = SearchItem()
    }
    
    init(searchItem : SearchItem?) {
        self.searchItem = searchItem ?? SearchItem()
        
        title = searchItem?.title ?? ""
        subtitle = searchItem?.authorName.count ?? 0 > 0 ? "by \(searchItem?.authorName.joined(separator: ", ") ?? "")" : ""
    }
    
    func getCoverImageURLString(size : ImageSize) -> URL {
        let coverImageURLString = "http://covers.openlibrary.org/b/"
        
        //just get the first one
        if searchItem.isbn.count > 0 {
            return URL(string: "\(coverImageURLString)isbn/\(searchItem.isbn[0])-\(size.rawValue).jpg")!
        }
        
        //no isbn?? lets check goodreads
        if searchItem.goodReadsID.count > 0 {
            return URL(string: "\(coverImageURLString)goodreads/\(searchItem.goodReadsID[0])-\(size.rawValue).jpg")!
        }
        
        //no isbn goodreads?? lets check lccns
        if searchItem.lccn.count > 0 {
            return URL(string: "\(coverImageURLString)goodreads/\(searchItem.lccn[0])-\(size.rawValue).jpg")!
        }
        
        return URL(string: "http://google.com")!
    }
}
