//
//  CoreDataStack.swift
//  CoreDataStack
//
//  Created by Alex Plescan on 30/01/2016.
//  Copyright © 2016 Alex Plescan. All rights reserved.
//

import CoreData

public struct CoreDataStack {
    let persistentStoreCoordinator: NSPersistentStoreCoordinator
    public let mainContext: NSManagedObjectContext
}
