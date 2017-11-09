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
    
    @IBOutlet weak var accountCollectionView: UICollectionView!
    @IBOutlet weak var activityTableView: UITableView!
    var activeAccount: AccountObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        accountManager.setUp()
        if accountManager.accountArray.count == 0 {
            performSegue(withIdentifier: "NewAccountTableViewController", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditRecordTableViewController" {
            let indexPath = activityTableView.indexPathForSelectedRow!
            let activity = accountManager.activityDictionary[activeAccount!]![indexPath.section]
            let record = accountManager.recordDictionary[activity]![indexPath.row]
            let atvc = segue.destination as! EditRecordTableViewController
            atvc.record = record
        }
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return activeAccount?.activities?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activeAccount?.activities?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecordTableViewCell", for: indexPath) as! RecordTableViewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "EditRecordTableViewController", sender: nil)
    }
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return accountManager.accountArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AccountCollectionViewCell", for: indexPath) as! AccountCollectionViewCell
        let account = accountManager.accountArray[indexPath.item]
        cell.accountNameLabel.text = account.name ?? "No name"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        activeAccount = accountManager.accountArray[indexPath.item]
    }
}
