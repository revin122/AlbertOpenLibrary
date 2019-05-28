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
    
    var message : String
    let title : String
    let subtitle : String
    var isInCoreData : Bool = false
    
    var details : [DetailsItemVM]
    
    var docItem : DocItem
    
    init() {
        title = ""
        subtitle = ""
        message = ""
        isInCoreData = false
        docItem = DocItem()
        details = []
    }
    
    init(docItem : DocItem?) {
        self.docItem = docItem ?? DocItem()
        
        message = ""
        title = docItem?.title ?? ""
        subtitle = self.docItem.authorName.count > 0 ? "by \(self.docItem.authorName.joined(separator: ", "))" : ""
        isInCoreData = CoreDataHandler.getInstance().isInCoreData(docItem: self.docItem)
        details = []
    }
    
    func getAuthorNames() -> String {
        return docItem.authorName.count > 0 ? "\(docItem.authorName.joined(separator: ", "))" : ""
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
    
    func generateSubParameters() {
        //clear the parameters
        details = []
        
        if docItem.isbn.count > 0 {
            details.append(DetailsItemVM(title: "ISBN", details: generateParameterValue(array: docItem.isbn)))
        }
        
        if docItem.publisher.count > 0 {
            details.append(DetailsItemVM(title: "Publisher", details: generateParameterValue(array: docItem.publisher)))
        }
        
        if docItem.firstPublishYear > 0 {
            details.append(DetailsItemVM(title: "First Publish Year", details: "\(docItem.firstPublishYear)"))
        }
        
        if docItem.publishYear.count > 0 {
            details.append(DetailsItemVM(title: "Publish Years", details: generateParameterValue(array: docItem.publishYear)))
        }
        
        if docItem.goodReadsID.count > 0 {
            details.append(DetailsItemVM(title: "Good Reads", details: generateGoodReadsParameterValue(array: docItem.goodReadsID)))
        }
        if docItem.amazonID.count > 0 {
            details.append(DetailsItemVM(title: "Amazon", details: generateAmazonParameterValue(array: docItem.amazonID)))
        }
        
        if docItem.lccn.count > 0 {
            details.append(DetailsItemVM(title: "LCCN", details: generateParameterValue(array: docItem.lccn)))
        }
    }
    
    private func generateParameterValue(array : [Any]) -> String {
        var value : String = ""
        
        for item in array {
            value = "\(item)\n"
        }
        
        return value
    }
    
    private func generateAmazonParameterValue(array : [String]) -> String {
        var value : String = ""
        
        for item in array {
            value = "https://www.amazon.com/dp/\(item)\n"
        }
        
        return value
    }
    
    private func generateGoodReadsParameterValue(array : [String]) -> String {
        var value : String = ""
        
        for item in array {
            value = "https://www.goodreads.com/book/show/\(item)\n"
        }
        
        return value
    }
    
    //both save and remove
    func processToCoreData() {
        if isInCoreData {
            refreshedDocCoreDataSingleton(message: CoreDataHandler.getInstance().removeItem(docItem: docItem), removed: true)
        } else {
            refreshedDocCoreDataSingleton(message: CoreDataHandler.getInstance().saveItem(docItem: docItem), removed: false)
        }
    }
    
    private func refreshedDocCoreDataSingleton(message : String, removed : Bool) {
        if message == "" {
            DocCoreDataSingleton.getInstance().refresh()
            isInCoreData = !isInCoreData
            self.message = "Item \(removed ? "Removed" : "Saved")"
        } else {
            self.message = message
        }
    }
}
