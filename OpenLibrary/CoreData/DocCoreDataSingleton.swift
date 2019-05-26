//
//  DocCoreDataSingleton.swift
//  OpenLibrary
//
//  Created by Remar Supnet on 5/25/19.
//  Copyright © 2019 Remar Supnet. All rights reserved.
//

import UIKit

class DocCoreDataSingleton {
    
    var docCoreDataItems : [DocItem]
    
    //Singleton
    static let instance = DocCoreDataSingleton()
    
    init() {
        docCoreDataItems = CoreDataHandler.getInstance().getAllDocItems()
    }
    
    class func getInstance() -> DocCoreDataSingleton {
        return instance
    }
    
    func refresh() {
        docCoreDataItems = CoreDataHandler.getInstance().getAllDocItems()
    }
}
