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
    
    var accountArray = [Account]()
    var activityDictionary = [Account: [Activity]]()
    
    func setUp() {
        accountArray = dataManager.fetchAccounts()
        accountArray.sort(by: {$0.name ?? "No name" > $1.name ?? "No name"})
        
        for account in accountArray {
            var activities = [Activity]()
            if account.activities != nil {
                activities = Array(account.activities!) as! [Activity]
            }
            activities.sort(by: { $0.name ?? "No name" > $1.name ?? "No name"})
            activityDictionary.updateValue(activities, forKey: account)
        }
    }
}
