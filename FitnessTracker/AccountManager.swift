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
    var activeAccount: AccountObject?

    func setUp() {
        accountArray = dataManager.fetchAccounts()
        accountArray.sort(by: {$0.name ?? "No name" < $1.name ?? "No name"})
        
        for account in accountArray {
            var activities = [ActivityObject]()
            if account.activities != nil {
                activities = Array(account.activities!) as! [ActivityObject]
            }
            activities.sort(by: { $0.name ?? "No name" < $1.name ?? "No name"})
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
        
        if accountArray.count > 0 {
            activeAccount = accountArray[0]
        }
    }
    
    func editAccount(_ account: AccountObject, new: Bool) {
        if new {
            accountArray.append(account)
        }
        activeAccount = account
        accountArray.sort(by: {$0.name ?? "No name" < $1.name ?? "No name"})
        dataManager.saveContext()
    }
    
    func addActivity(_ activity: ActivityObject, account: AccountObject) {
        account.addToActivities(activity)
        var activityArray = activityDictionary[account]
        
        if activityArray == nil {
            activityArray = [ActivityObject]()
        }
        
        activityArray!.append(activity)
        activityArray!.sort(by: { $0.name ?? "No name" < $1.name ?? "No name"})
        activityDictionary.updateValue(activityArray!, forKey: account)
    }
    
    func addRecord(_ record: RecordObject, activity: ActivityObject) {
        
        //checks if activity has changed
        if let recordActivity = record.activity {
            if recordActivity != activity {
                var records = recordDictionary[recordActivity]!
                let recordIndex = records.index(of: record)
                if let recordIndex = recordIndex {
                    records.remove(at: recordIndex)
                    recordDictionary.updateValue(records, forKey: recordActivity)
                }
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
    
    func getActivityArrayForAccount(_ account: AccountObject) -> [ActivityObject] {
        if activityDictionary[account] == nil {
            activityDictionary.updateValue([ActivityObject](), forKey: account)
        }
        return activityDictionary[account]!
    }
    
    func setActiveAccountAtIndex(_ index: Int) {        
        activeAccount = accountArray[index]
    }

}
