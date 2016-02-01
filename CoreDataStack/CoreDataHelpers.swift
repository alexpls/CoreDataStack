//
//  CoreDataHelpers.swift
//  CoreDataStack
//
//  Created by Alex Plescan on 30/01/2016.
//  Copyright © 2016 Alex Plescan. All rights reserved.
//

import CoreData

public func saveContext(context: NSManagedObjectContext, synchronous: Bool = false, completion: ((CoreDataSaveResult) -> Void)? = nil) {
    guard context.hasChanges else { return }
    
    let block = {
        do {
            try context.save()
            completion?(.Success)
        } catch let err as NSError {
            completion?(.Failure(err))
        }
    }
    
    synchronous ? context.performBlockAndWait(block) : context.performBlock(block)
}

public class FetchRequest <T: NSManagedObject>: NSFetchRequest {
    public init(entity: NSEntityDescription) {
        super.init()
        self.entity = entity
    }
}

public func fetch <T: NSManagedObject>(request request: FetchRequest<T>, inContext context: NSManagedObjectContext) throws -> [T] {
    var results = [AnyObject]()
    var caughtError: NSError?
    
    context.performBlockAndWait {
        do {
            results = try context.executeFetchRequest(request)
        } catch {
            caughtError = error as NSError
        }
    }
    
    guard caughtError == nil else {
        throw caughtError!
    }
    
    return results as! [T]
}

public func entity(name name: String, context: NSManagedObjectContext) -> NSEntityDescription {
    return NSEntityDescription.entityForName(name, inManagedObjectContext: context)!
}