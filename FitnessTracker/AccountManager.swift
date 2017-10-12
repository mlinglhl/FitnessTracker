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
    
    func setUp() {
        accountArray =
    }
}
