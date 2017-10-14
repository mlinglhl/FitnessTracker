//
//  HomeViewController.swift
//  FitnessTracker
//
//  Created by Minhung Ling on 2017-10-12.
//  Copyright © 2017 Minhung Ling. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
let accountManager = AccountManager.sharedInstance
    
    @IBOutlet weak var activityTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        accountManager.setUp()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ActivityTableViewController" {
            let indexPath = activityTableView.indexPathForSelectedRow!
            let account = accountManager.accountArray[indexPath.section]
            let activities = accountManager.activityDictionary[account]
            let activity = activities![indexPath.row]
            let atvc = segue.destination as! ActivityTableViewController
            atvc.activity = activity
        }
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return accountManager.accountArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let account = accountManager.accountArray[section]
        return account.activities?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityTableViewCell", for: indexPath) as! ActivityTableViewCell
        return cell
    }
}
