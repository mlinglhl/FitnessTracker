//
//  AccountManager.swift
//  FitnessTracker
//
//  Created by Minhung Ling on 2017-10-12.
//  Copyright © 2017 Minhung Ling. All rights reserved.
//

import UIKit

class AccountManager: NSObject {
    static let sharedInstance = AccountManager()
    private override init() {}
    
    let dataManager = DataManager.sharedInstance
    var accountArray = [AccountObject]()
    var activityDictionary = [AccountObject: [ActivityObject]]()
    var recordDictionary = [ActivityObject: [RecordObject]]()
    
    func setUp() {
        accountArray = dataManager.fetchAccounts()
        accountArray.sort(by: {$0.name ?? "No name" > $1.name ?? "No name"})
        
        for account in accountArray {
            var activities = [ActivityObject]()
            if account.activities != nil {
                activities = Array(account.activities!) as! [ActivityObject]
            }
            activities.sort(by: { $0.name ?? "No name" > $1.name ?? "No name"})
            activityDictionary.updateValue(activities, forKey: account)
            
            for activity in activities {
                var records = [RecordObject]()
                if activity.records != nil {
                    records = Array(activity.records!) as! [RecordObject]
                }
                records.sort(by: {$0.weight?.intValue ?? 0 > $1.weight?.intValue ?? 0})
                recordDictionary.updateValue(records, forKey: activity)
            }
        }
    }
    
    func editAccount(_ account: AccountObject, new: Bool) {
        if new {
            accountArray.append(account)
        }
        accountArray.sort(by: {$0.name ?? "No name" > $1.name ?? "No name"})
        dataManager.saveContext()
    }
    
    func addActivity(_ activity: ActivityObject, account: AccountObject) {
        account.addToActivities(activity)
        var activityArray = activityDictionary[account]
        
        if activityArray == nil {
            activityArray = [ActivityObject]()
        }
        
        activityArray!.append(activity)
        activityArray!.sort(by: { $0.name ?? "No name" > $1.name ?? "No name"})
        activityDictionary.updateValue(activityArray!, forKey: account)
    }
    
    func addRecord(_ record: RecordObject, activity: ActivityObject) {
        
        if let activity = record.activity {
            var records = recordDictionary[activity]!
            let recordIndex = records.index(of: record)
            if let recordIndex = recordIndex {
                records.remove(at: recordIndex)
                recordDictionary.updateValue(records, forKey: activity)
            }
        }
        
        activity.addToRecords(record)
        
        var recordArray = recordDictionary[activity]
        
        if recordArray == nil {
            recordArray = [RecordObject]()
        }
        
        if !recordArray!.contains(record) {
            recordArray!.append(record)
        }
        
        recordArray!.sort(by: {$0.weight?.intValue ?? 0 > $1.weight?.intValue ?? 0})
        recordDictionary.updateValue(recordArray!, forKey: activity)
    }
}
