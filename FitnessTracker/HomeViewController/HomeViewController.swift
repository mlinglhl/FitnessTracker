//
//  HomeViewController.swift
//  FitnessTracker
//
//  Created by Minhung Ling on 2017-10-12.
//  Copyright © 2017 Minhung Ling. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    //MARK: Properties
    let accountManager = AccountManager.sharedInstance
    @IBOutlet weak var recordTableView: UITableView!
    @IBOutlet weak var accountCollectionView: UICollectionView!
    var activeAccount: AccountObject?
    
    //MARK: Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        accountManager.setUp()
        if accountManager.accountArray.count == 0 {
            performSegue(withIdentifier: "EditAccountTableViewController", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditRecordTableViewController" {
            if let indexPath = recordTableView.indexPathForSelectedRow {
                let activity = accountManager.activityDictionary[activeAccount!]![indexPath.section]
                let record = accountManager.recordDictionary[activity]![indexPath.row]
                let atvc = segue.destination as! EditRecordTableViewController
                atvc.record = record
            }
        }
        
        if segue.identifier == "EditAccountTableViewController" {
            let ertvc = segue.destination as! EditAccountTableViewController
            ertvc.reloadDelegate = self
        }
    }
}

//MARK: TableView Methods
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return activeAccount?.activities?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let activities = accountManager.activityDictionary[activeAccount!]!
        return activities[section].name
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let activities = accountManager.activityDictionary[activeAccount!] else {
            return 0
        }
        
        guard let records = accountManager.recordDictionary[activities[section]] else {
            return 0
        }
        
        return records.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecordTableViewCell", for: indexPath) as! RecordTableViewCell
        let activity = accountManager.activityDictionary[activeAccount!]![indexPath.section]
        let record = accountManager.recordDictionary[activity]![indexPath.row]
        let weight = record.weight?.stringValue ?? "n/a"
        cell.weightLabel.text = "Weight: \(weight)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "EditRecordTableViewController", sender: nil)
    }
}

//MARK: CollectionView Methods
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
        recordTableView.reloadData()
    }
}

//MARK: Protocol Methods
extension HomeViewController: ReloadDataProtocol {
    func reloadAllData() {
        accountCollectionView.reloadData()
        recordTableView.reloadData()
    }
}
