//
//  ActivityTableViewController.swift
//  FitnessTracker
//
//  Created by Minhung Ling on 2017-10-12.
//  Copyright © 2017 Minhung Ling. All rights reserved.
//

import UIKit

class EditRecordTableViewController: UITableViewController {
    
    @IBOutlet weak var weightInLbsSegmentedControl: UISegmentedControl!
    @IBOutlet weak var activityCollectionView: UICollectionView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var weightSlider: UISlider!
    @IBOutlet weak var repSlider: UISlider!
    
    var record: RecordObject!
    var account: AccountObject!
    let accountManager = AccountManager.sharedInstance
    var newActivity = false
    var activityIndex: Int?
    var reloadDataDelegate: ReloadDataProtocol!
    
    @IBOutlet weak var repsAmountLabel: UILabel!
    @IBOutlet weak var weightAmountLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        //disables slide to go back to improve usability
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        if record == nil {
            record = DataManager.sharedInstance.generateRecord()
            return
        }
        
        setExistingRecordValues()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if record.activity == nil {
            DataManager.sharedInstance.deleteObject(record)
        }
        super.viewWillDisappear(animated)
    }

    override func viewDidDisappear(_ animated: Bool) {
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    //if editing an existing record, will set the sliders and labels to the record's values
    func setExistingRecordValues() {
        let activityArray = accountManager.activityDictionary[account]!
        
        activityIndex = activityArray.index(of: record.activity!) ?? 0
        repsAmountLabel.text = "\(record.repetitions)"
        repSlider.value = Float(record.repetitions)
        weightAmountLabel.text = "\(record.weight ?? 0)"
        weightSlider.value = record.weight?.floatValue ?? 0
    }
    
    //MARK: Methods to update labels associated with sliders
    @IBAction func repSliderChanged(_ sender: UISlider) {
        repsAmountLabel.text = "\(Int(sender.value))"
    }
    
    @IBAction func weightSliderChanged(_ sender: UISlider) {
        weightAmountLabel.text = "\(Int(sender.value))"
    }
    
    //MARK: Save function
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        
        //ensure an activity is selected
        guard let unwrappedActivityIndex = activityIndex else {
            createAlertWithTitle("No Activity", message: "Please select an activity")
            return
        }
        
        let activityArray = accountManager.activityDictionary[account]!
        
        //ensure if New Activity is selected, a name is entered
        guard nameTextField.text != "" || unwrappedActivityIndex != activityArray.count else {
            createAlertWithTitle("No Activity Name", message: "Please name your activity.")
            return
        }
        
        let dataManager = DataManager.sharedInstance
        var activity: ActivityObject!

        //creates new activity is new activity is selected
        if unwrappedActivityIndex == activityArray.count {
            activity = dataManager.generateActivity()
            activity.name = nameTextField.text
            accountManager.addActivity(activity, account: account)
        } else {
            activity = activityArray[unwrappedActivityIndex]
        }
        
        //update weight and repetition values based on sliders
        record.weight = NSDecimalNumber(value: Int(weightSlider.value))
        record.repetitions = Int16(Int(repSlider.value))
        
        switch weightInLbsSegmentedControl.selectedSegmentIndex {
        case 0:
            record.weightInPounds = true
            break
        case 1:
            record.weightInPounds = false
            break
        default:
            record.weightInPounds = true
            break
        }
        
        accountManager.addRecord(record, activity: activity)

        dataManager.saveContext()
        reloadDataDelegate.reloadAllData()
        navigationController?.popViewController(animated: true)
    }
    
    func createAlertWithTitle(_ title: String, message: String) {
        let alertController = UIAlertController(title: "No Activity", message: "Please select an activity.", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alertController, animated: true, completion: nil)

    }
    
}

//MARK: TableView Methods
extension EditRecordTableViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 && newActivity == false {
            return 0
        }
        return 60
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 && newActivity == false {
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
        activityIndex = indexPath.item
        let activityArray = accountManager.activityDictionary[account]!
        tableView.beginUpdates()
        if indexPath.item + 1 > activityArray.count {
            newActivity = true
        } else {
            newActivity = false
            nameTextField.text = ""
        }
        tableView.endUpdates()
    }
}
