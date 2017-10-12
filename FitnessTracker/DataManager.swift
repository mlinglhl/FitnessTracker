//
//  DataManager.swift
//  FitnessTracker
//
//  Created by Minhung Ling on 2017-10-12.
//  Copyright © 2017 Minhung Ling. All rights reserved.
//

import UIKit
import CoreData

class DataManager: NSObject {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    static let sharedInstance = DataManager()
    private override init() {}
    
    func saveContext() {
        appDelegate.saveContext()
    }
    
    func generate(_ objectName: String) -> NSManagedObject {
        let object = NSEntityDescription.insertNewObject(forEntityName: objectName, into: appDelegate.persistentContainer.viewContext)
        return object
    }
    
    func generateAccount() -> Account {
        let account = generate("Account") as! Account
        return account
    }
    
    func generateActivity() -> Activity {
        let activity = generate("Activity") as! Activity
        return activity
    }
    
    func fetchActivities() -> [Activity] {
        let request = NSFetchRequest<Activity>(entityName: "Activity")
        do {
            let activityArray = try appDelegate.persistentContainer.viewContext.fetch(request)
            return activityArray
        } catch {
            return [Activity]()
        }
    }
}
