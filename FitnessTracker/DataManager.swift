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
    
    private func generate(_ objectName: String) -> NSManagedObject {
        let object = NSEntityDescription.insertNewObject(forEntityName: objectName, into: appDelegate.persistentContainer.viewContext)
        return object
    }
    
    func generateAccount() -> AccountObject {
        let account = generate("AccountObject") as! AccountObject
        return account
    }
    
    func generateActivity() -> ActivityObject {
        let activity = generate("ActivityObject") as! ActivityObject
        return activity
    }
    
    func generateRecord() -> RecordObject {
        let record = generate("RecordObject") as! RecordObject
        return record
    }

    func fetchAccounts() -> [AccountObject] {
        let request = NSFetchRequest<AccountObject>(entityName: "AccountObject")
        do {
            let accountArray = try appDelegate.persistentContainer.viewContext.fetch(request)
            return accountArray
        } catch {
            return [AccountObject]()
        }
    }
}
