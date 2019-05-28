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
    var typeOptions = ["All", "Author", "Title"]
    
    var delegate : SearchResultVMDelegate?
    
    var currentSearchText : String = ""
    var currentSearchType : String = ""
    var selectedItem : DocItemVM = DocItemVM()
    
    private var searchResult : SearchResult? {
        didSet {
            delegate?.searchingDone()
        }
    }
    var showMessage : String? {
        didSet {
            delegate?.generatedMessage()
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
    
    func getItem(index : Int) -> DocItemVM {
        
        let docItem = searchResult?.results[index]
        
        let docItemVM = DocItemVM(docItem: docItem)
        
        //check if it exists in core data
        for coreDataDocItem : DocItem in DocCoreDataSingleton.getInstance().docCoreDataItems {
            if docItem?.key == coreDataDocItem.key {
                docItemVM.isInCoreData = true
                break
            }
        }
        
        return docItemVM
    }
    
    //both save and remove
    func processToCoreData(docIndex : Int) {
        //TODO a check if item already exists in coredata
        let docItemVM = getItem(index: docIndex)
        
        if docItemVM.isInCoreData {
            refreshedDocCoreDataSingleton(message: CoreDataHandler.getInstance().removeItem(docItem: docItemVM.docItem), removed: true)
        } else {
            refreshedDocCoreDataSingleton(message: CoreDataHandler.getInstance().saveItem(docItem: searchResult!.results[docIndex]), removed: false)
        }
    }
    
    private func refreshedDocCoreDataSingleton(message : String, removed : Bool) {
        if message == "" {
            DocCoreDataSingleton.getInstance().refresh()
            
            showMessage = "Item \(removed ? "Removed" : "Saved")"
            delegate?.searchingDone()
        } else {
            showMessage = message
        }
    }
    
    /*****
     Search API Delegate
     ****/
    
    func searchResults(searchResults : SearchResult) {
        
        //just add the previous results to this new array while keeping the other stuff intact
        if page > 1 {
            searchResults.addPreviousEntries(previousResults: searchResult?.results ?? [])
        }
        
        searchResult = searchResults
    }
    
    func apiFailed(error: Error?) {
        //TODO Parse Error
        
        showMessage = "Could not complete process. Please try again later."
    }
    
    //End of Search API Delegate
 
}

protocol SearchResultVMDelegate {
    func searchingDone()
    func generatedMessage()
}
