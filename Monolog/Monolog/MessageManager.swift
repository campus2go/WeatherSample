//
//  MessageManager.swift
//  Monolog
//
//  Created by Hermann Klecker on 08/04/16.
//  Copyright © 2016 Hermann Klecker. All rights reserved.
//

import Foundation

import UIKit

import CoreData

// This class is merely a container for a collection of static methods accessing core data 
// and for the "global" variable, an array holding all messages available. 

// You could as well go for a singleton here. However, singletons can be more difficult when it comes to testing than static stuff.

// Strictly spoken there is not even a need for the array of all messages. You could use CD to the extend that all methods access
// core data directly which would enable core data to fully manage the memory used by its managed objects and to react to 
// memory warnings accordingly.

class MessageManager {

    // Schlüssel für Entitäten und Eigenschaften als Konstante
    private static let entityMessage = "Message"
    private static let attribTimestamp = "timestamp"
    
    private static var messages : [Message]?
    
    static func addMessage (newMessage: String) {
        
        let entity =  NSEntityDescription.entityForName(entityMessage,
            inManagedObjectContext:moContext())
        
        let message = Message(entity: entity!, insertIntoManagedObjectContext: moContext())
        
//        let message = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: moContext()) as! Message
        message.message = newMessage
        message.timestamp = NSDate()
        
        messages?.insert(message, atIndex: 0)
        
        save()

    }
    
    static func getNumberOfMessages() -> Int {
        return allMessages().count
    }
    
    static func getMessage(atIndex index : Int) -> Message? {
        return allMessages()[index]
    }
    
    private static func allMessages() -> [Message] {
        
        if messages == nil {
            let fetchRequest = NSFetchRequest(entityName: entityMessage)
            let sortDesc = NSSortDescriptor(key: attribTimestamp, ascending: false)
            fetchRequest.sortDescriptors = [sortDesc]
            do {
                let results = try moContext().executeFetchRequest(fetchRequest)
                messages = results as? [Message]
            } catch let error as NSError {
                print("Could not fetch \(error), \(error.userInfo)")
                return [Message]()
            }
        }
        return messages!
    }
    

    private static func save() {
        do {
            try moContext().save()
        } catch let error as NSError {
            print("Error saving the new message: \(error.userInfo)")
        }
    }
    
    private static func moContext () -> NSManagedObjectContext {
        
        // get the MOContext from the app delegate
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        return appDelegate.managedObjectContext
        
    }
    
}
