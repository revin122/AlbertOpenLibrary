//
//  CoreDataVM.swift
//  OpenLibrary
//
//  Created by Remar Supnet on 5/25/19.
//  Copyright © 2019 Remar Supnet. All rights reserved.
//

import UIKit

class CoreDataVM {

    var docItemsVM : [DocItemVM]
    var selectedItem : DocItemVM = DocItemVM()
    
    //no need for delegates since we dont have an API call
    var generatedMessage : String
    
    init() {
        generatedMessage = ""
        docItemsVM = DocCoreDataSingleton.getInstance().docCoreDataItems.map{ DocItemVM(docItem: $0) }
        
        for item : DocItemVM in docItemsVM {
            item.isInCoreData = true
        }
    }
    
    //update the contents
    func update() {
        DocCoreDataSingleton.getInstance().refresh()
        docItemsVM = DocCoreDataSingleton.getInstance().docCoreDataItems.map{ DocItemVM(docItem: $0) }
        
        for item : DocItemVM in docItemsVM {
            item.isInCoreData = true
        }
    }
    
    func removeItem(index : Int) {
        generatedMessage = CoreDataHandler.getInstance().removeItem(docItem: docItemsVM[index].docItem)
        
        update()
    }
}
