//
//  CoreDataStackFactory.swift
//  CoreDataStack
//
//  Created by Alex Plescan on 30/01/2016.
//  Copyright © 2016 Alex Plescan. All rights reserved.
//

import Foundation
import CoreData

public typealias CoreDataCompletionHandler = (CoreDataStackLoadedResult) -> Void
public typealias PersistentStoreOptions = [NSObject: AnyObject]

public enum CoreDataStackLoadedResult {
    case Success(CoreDataStack)
    case Failure(NSError)
}

public enum CoreDataSaveResult {
    case Success
    case Failure(NSError)
}

private let defaultOptions = [NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: true]

public class CoreDataStackFactory {
    let model: CoreDataModel
    let options: PersistentStoreOptions
    
    public init(model: CoreDataModel, options: PersistentStoreOptions = defaultOptions) {
        self.model = model
        self.options = options
    }
    
    public func createStackInBackground(completion: CoreDataCompletionHandler) {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: model.managedObjectModel)
        let storeURL = model.storeURL
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) {
            do {
                try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL, options: self.options)
                let mainContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
                mainContext.persistentStoreCoordinator = coordinator
                
                let stack = CoreDataStack(
                    persistentStoreCoordinator: coordinator,
                    mainContext: mainContext)
                
                dispatch_async(dispatch_get_main_queue()) {
                    completion(.Success(stack))
                }
                
            } catch (let err as NSError) {
                dispatch_async(dispatch_get_main_queue()) {
                    completion(.Failure(err))
                }
            }
        }
    }
}

