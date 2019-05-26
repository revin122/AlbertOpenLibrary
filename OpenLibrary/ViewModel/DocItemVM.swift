//
//  SearchItemVM.swift
//  OpenLibrary
//
//  Created by Remar Supnet on 5/23/19.
//  Copyright © 2019 Remar Supnet. All rights reserved.
//

import UIKit

class DocItemVM {
    
    enum ImageSize : Character {
        case small = "S"
        case medium = "M"
    }
    
    let title : String
    let subtitle : String
    var isInCoreData : Bool = false
    
    var docItem : DocItem
    
    init() {
        title = ""
        subtitle = ""
        isInCoreData = false
        docItem = DocItem()
    }
    
    init(docItem : DocItem?) {
        self.docItem = docItem ?? DocItem()
        
        title = docItem?.title ?? ""
        subtitle = docItem?.authorName.count ?? 0 > 0 ? "by \(docItem?.authorName.joined(separator: ", ") ?? "")" : ""
        isInCoreData = CoreDataHandler.getInstance().isInCoreData(docItem: self.docItem)
    }
    
    func getCoverImageURLString(size : ImageSize) -> URL {
        let coverImageURLString = "http://covers.openlibrary.org/b/"
        
        //just get the first one
        if docItem.isbn.count > 0 {
            return URL(string: "\(coverImageURLString)isbn/\(docItem.isbn[0])-\(size.rawValue).jpg")!
        }
        
        //no isbn?? lets check goodreads
        if docItem.goodReadsID.count > 0 {
            return URL(string: "\(coverImageURLString)goodreads/\(docItem.goodReadsID[0])-\(size.rawValue).jpg")!
        }
        
        //no isbn goodreads?? lets check lccns
        if docItem.lccn.count > 0 {
            return URL(string: "\(coverImageURLString)goodreads/\(docItem.lccn[0])-\(size.rawValue).jpg")!
        }
        
        return URL(string: "http://google.com")!
    }
}
