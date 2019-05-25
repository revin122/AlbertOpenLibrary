//
//  OpenLibraryAPI.swift
//  OpenLibrary
//
//  Singleton that does the API Calls for Open Library API
//
//  Created by Remar Supnet on 5/22/19.
//  Copyright © 2019 Remar Supnet. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class OpenLibraryAPI {
    
    //Singleton
    static let instance = OpenLibraryAPI()
    
    let searchURLString : String
    
    var currentRequest : DataRequest?
    
    init() {
        searchURLString = "http://openlibrary.org/search.json"
    }
    
    class func getInstance() -> OpenLibraryAPI {
        return instance
    }
    
    /*****
     GET
     ****/
    
    private func queryURL(params: [String: String], urlString : String = "") -> URL {
        var components = URLComponents(string: "\(urlString)")
        components?.queryItems = params.map { element in URLQueryItem(name: element.key, value: element.value) }
        
        return (components?.url)!
    }
    
    func search(text : String, type: String, page : Int, searchAPIDelegate : SearchAPIDelegate) {
        //start off
        var parameters : [String : String] = [:]
        
        //check the type and add the appropriate query item
        var typeKey = ""
        switch type {
        case "Author":
            typeKey = "author"
        case "Title":
            typeKey = "title"
        default:
            typeKey = "q"
        }
        
        //add the search text
        parameters[typeKey] = text
        
        //add the page
        if page > 1 {
            parameters["page"] = "\(page)"
        }
        
        //this should form the complete url
        let completeURL = queryURL(params: parameters, urlString: searchURLString)
        
        //cancel any ongoing request
        currentRequest?.cancel()
        
        //lets start API Call
        currentRequest = Alamofire.request(completeURL,
                          method: .get,
                          parameters: nil)
            .validate(statusCode: 200..<300)
            .responseJSON { (response) in
                if response.error != nil {
                    searchAPIDelegate.apiFailed(error: response.error)
                } else {
                    let json = JSON(response.result.value!)
                    
                    //lets make the model
                    let searchResult = SearchResult(json: json)

                   searchAPIDelegate.searchResults(searchResults: searchResult)
                }
        }
    }
}

protocol SearchAPIDelegate : APIFailedDelegate {
    func searchResults(searchResults : SearchResult)
}

protocol APIFailedDelegate {
    func apiFailed(error : Error?)
}
