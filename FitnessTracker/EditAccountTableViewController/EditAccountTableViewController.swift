//
//  NewAccountTableViewController.swift
//  FitnessTracker
//
//  Created by Minhung Ling on 2017-11-09.
//  Copyright © 2017 Minhung Ling. All rights reserved.
//

import UIKit

class EditAccountTableViewController: UITableViewController {
    var account: AccountObject?
    var reloadDelegate: ReloadDataProtocol!

    var newAccount = false
    var savePressed = false
    
    @IBOutlet weak var accountNameTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        accountNameTextField.text = account?.name
        if account == nil {
            account = DataManager.sharedInstance.generateAccount()
            newAccount = true
        }
    }

    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        savePressed = true
        account!.name = accountNameTextField.text
        let accountManager = AccountManager.sharedInstance
        accountManager.editAccount(account!, new: newAccount)
        reloadDelegate.reloadAllData()
        navigationController?.popViewController(animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if !savePressed && newAccount {
            DataManager.sharedInstance.deleteObject(account!)
        }
    }
}
