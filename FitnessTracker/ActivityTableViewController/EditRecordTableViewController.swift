//
//  ActivityTableViewController.swift
//  FitnessTracker
//
//  Created by Minhung Ling on 2017-10-12.
//  Copyright © 2017 Minhung Ling. All rights reserved.
//

import UIKit

class EditRecordTableViewController: UITableViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var weightSlider: UISlider!
    @IBOutlet weak var repSlider: UISlider!
    
    var record: RecordObject?
    var account: AccountObject!
    let accountManager = AccountManager.sharedInstance
    var newAccount = false
    
    @IBOutlet weak var repsAmountLabel: UILabel!
    @IBOutlet weak var weightAmountLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    @IBAction func repSliderChanged(_ sender: UISlider) {
        repsAmountLabel.text = "\(Int(sender.value))"
    }
    
    @IBAction func weightSliderChanged(_ sender: UISlider) {
        weightAmountLabel.text = "\(Int(sender.value))"
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        let dataManager = DataManager.sharedInstance
        if record == nil {
            record = dataManager.generateRecord()
        }
        record!.weight = NSDecimalNumber(value: weightSlider.value)
        record!.repetitions = Int16(repSlider.value)
    }
}

//MARK: TableView Methods
extension EditRecordTableViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 && newAccount == false {
            return 0
        }
        return 60
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 && newAccount == false {
            return 0
        }
        return 20
    }
}

//MARK: Collection View Methods
extension EditRecordTableViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let activities = accountManager.activityDictionary[account] else {
            return 1
        }
        return activities.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ActivityCollectionViewCell", for: indexPath) as! ActivityCollectionViewCell
        let activityArray = accountManager.activityDictionary[account]!
        
        if indexPath.item + 1 > activityArray.count {
            cell.nameLabel.text = "New Activity"
            return cell
        }
        
        let activity = activityArray[indexPath.item]
        cell.nameLabel.text = activity.name
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let activityArray = accountManager.activityDictionary[account]!
        tableView.beginUpdates()
        if indexPath.item + 1 > activityArray.count {
            newAccount = true
        } else {
            newAccount = false
            nameTextField.text = ""
        }        
        tableView.endUpdates()
    }
}
