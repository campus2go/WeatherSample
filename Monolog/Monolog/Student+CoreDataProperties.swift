//
//  Student+CoreDataProperties.swift
//  Monolog
//
//  Created by Hermann Klecker on 13/04/16.
//  Copyright © 2016 Hermann Klecker. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Student {

    @NSManaged var name: String?
    @NSManaged var imageUrl: String?
    @NSManaged var messages: NSSet?

}
