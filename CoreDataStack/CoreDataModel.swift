//
//  CoreDataModel.swift
//  CoreDataStack
//
//  Created by Alex Plescan on 28/01/2016.
//  Copyright © 2016 Alex Plescan. All rights reserved.
//

import CoreData

public struct CoreDataModel {
    let managedObjectModelFileName: String
    let databaseFileName: String
    let bundle: NSBundle
    
    public init(managedObjectModelFileName: String, databaseFileName: String, bundle: NSBundle) {
        self.managedObjectModelFileName = managedObjectModelFileName
        self.databaseFileName = databaseFileName
        self.bundle = bundle
    }
    
    var managedObjectModel: NSManagedObjectModel {
        guard let modelURL = bundle.URLForResource(managedObjectModelFileName, withExtension: "momd") else {
            fatalError("Uh, shit. You have no mom for \(managedObjectModelFileName)")
        }
        
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }
    
    var applicationDocumentsDirectory: NSURL {
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }
    
    var storeURL: NSURL {
        return applicationDocumentsDirectory.URLByAppendingPathComponent("\(databaseFileName).sqlite")
    }
}
