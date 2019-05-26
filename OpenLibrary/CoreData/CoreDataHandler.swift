//
//  CoreDataHandler.swift
//  OpenLibrary
//
//  Created by Remar Supnet on 5/25/19.
//  Copyright © 2019 Remar Supnet. All rights reserved.
//

import UIKit
import CoreData

class CoreDataHandler {
    
    //Singleton
    static let instance = CoreDataHandler()
    
    //so this container should only be instantianted when going to be used
    lazy var persistentContainer: NSPersistentContainer  = {
        
        let container = NSPersistentContainer(name: "openlibrarycd")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Fatal Error \(error)")
            }
        })
        return container
    }()
    
    init() {
    }
    
    class func getInstance() -> CoreDataHandler {
        return instance
    }
    
    //save
    private func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                fatalError("Fatal Error \(error)")
            }
        }
    }
    
    func saveItem(docItem : DocItem) -> String {
        var message : String = ""
        
        let context = self.persistentContainer.viewContext
        
        let docEntity = NSEntityDescription.entity(forEntityName: "Doc", in: context)
        let newDoc = NSManagedObject(entity: docEntity!, insertInto: context)
        
        newDoc.setValue(docItem.key, forKey: "key")
        newDoc.setValue(docItem.title, forKey: "title")
        newDoc.setValue(docItem.amazonID, forKey: "amazonID")
        newDoc.setValue(docItem.authorKey, forKey: "authorKey")
        newDoc.setValue(docItem.authorName, forKey: "authorName")
        newDoc.setValue(docItem.coverEditionKey, forKey: "coverEditionKey")
        newDoc.setValue(docItem.firstPublishYear, forKey: "firstPublishYear")
        newDoc.setValue(docItem.goodReadsID, forKey: "goodReadsID")
        newDoc.setValue(docItem.isbn, forKey: "isbn")
        newDoc.setValue(docItem.lccn, forKey: "lccn")
        newDoc.setValue(docItem.publisher, forKey: "publisher")
        newDoc.setValue(docItem.publishYear, forKey: "publishYear")
        
        do {
            try context.save()
        } catch {
            message = "Could not save in Core Data"
        }
        
        return message
    }
    
    func getAllDocItems() -> [DocItem] {
        let context = self.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Doc")
        request.returnsObjectsAsFaults = false
        
        var docItemArray : [DocItem] = []
        
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                
//                print("Get All \(data.value(forKey: "key") as? String ?? "")")
                
                docItemArray.append(DocItem(isbn: data.value(forKey: "isbn") as? [String] ?? [],
                                            authorName: data.value(forKey: "authorName") as? [String] ?? [],
                                            goodReadsID: data.value(forKey: "goodReadsID") as? [String] ?? [] ,
                                            amazonID: data.value(forKey: "amazonID") as? [String] ?? [],
                                            authorKey: data.value(forKey: "authorName") as? [String] ?? [],
                                            coverEditionKey: data.value(forKey: "coverEditionKey") as? String ?? "",
                                            title: data.value(forKey: "title") as? String ?? "",
                                            publishYear: data.value(forKey: "publishYear") as? [Int] ?? [],
                                            firstPublishYear: (data.value(forKey: "firstPublishYear") as? NSDecimalNumber)?.intValue ?? 0,
                                            key: data.value(forKey: "key") as? String ?? "",
                                            publisher: data.value(forKey: "publisher") as? [String] ?? [],
                                            lccn: data.value(forKey: "lccn") as? [String] ?? []))
            }
            
        } catch {
            print("Get All Doc Items Failed")
        }
        
        return docItemArray
    }
    
    func removeItem(docItem : DocItem) -> String {
        var message : String = ""
        
        let context = self.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Doc")
        request.returnsObjectsAsFaults = false
        
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                
                if docItem.key == data.value(forKey: "key") as? String ?? "" {
                    context.delete(data)
                }
            }
            
            //dont forget to save or else it wont get removed
            try context.save()
            
        } catch {
            message = "Remove Item Failed"
        }
        
        return message
    }
    
    func isInCoreData(docItem : DocItem) -> Bool {
        let context = self.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Doc")
        request.returnsObjectsAsFaults = false
        
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                
                //just need to check the unique key
                let itemKey = data.value(forKey: "key") as? String ?? ""
                
                return docItem.key == itemKey
            }
            
        } catch {
            print("Check Items Failed")
        }
        
        return false
    }
}
