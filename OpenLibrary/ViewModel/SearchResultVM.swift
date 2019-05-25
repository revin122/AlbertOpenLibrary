//
//  SearchResultVM.swift
//  OpenLibrary
//
//  Created by Remar Supnet on 5/23/19.
//  Copyright © 2019 Remar Supnet. All rights reserved.
//

import UIKit

class SearchResultVM : SearchAPIDelegate {
    
    var page : Int
    var delegate : SearchResultVMDelegate?
    
    var currentSearchText : String = ""
    var currentSearchType : String = ""
    
    private var searchResult : SearchResult? {
        didSet {
            delegate?.searchingDone()
        }
    }
    var errorMessage : String? {
        didSet {
            delegate?.errorFound()
        }
    }
    
    init() {
        page = 1
    }
    
    func doASearch(text : String, type : String?) {
        page = 1
        self.currentSearchText = text
        self.currentSearchType = type ?? ""
        
        OpenLibraryAPI.getInstance().search(text: currentSearchText, type: currentSearchType , page: page, searchAPIDelegate: self)
    }
    
    func getMaxPageItemIndex() -> Int {
        //start somehow will increment by 100 in the open library API
        return 90 + (searchResult?.start ?? 0 * (page - 1))
    }
    
    func goToNextPage() {
        page += 1
        OpenLibraryAPI.getInstance().search(text: currentSearchText, type: currentSearchType , page: page, searchAPIDelegate: self)
    }
    
    func totalItems() -> Int {
        return searchResult?.numFound ?? 0
    }
    
    func getItem(index : Int) -> SearchItemVM {
        return SearchItemVM(searchItem: searchResult?.results[index])
    }
    
    func saveItemToCoreData(index : Int) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Book", in: context)
        let newUser = NSManagedObject(entity: entity!, insertInto: context)
    }
    
    func removeItemFromCoreData(index : Int) {
        
    }
    
    /*****
     Search API Delegate
     ****/
    
    func searchResults(searchResults : SearchResult) {
        if page > 1 {
            searchResults.addPreviousEntries(previousResults: searchResult?.results ?? [])
        }
        
        searchResult = searchResults
    }
    
    func apiFailed(error: Error?) {
        //TODO Parse Error
        
        errorMessage = "Could not complete process. Please try again later."
    }
    
    //End of Search API Delegate
 
}

protocol SearchResultVMDelegate {
    func searchingDone()
    func errorFound()
}
