//
//  ActivityTableViewController.swift
//  FitnessTracker
//
//  Created by Minhung Ling on 2017-10-12.
//  Copyright © 2017 Minhung Ling. All rights reserved.
//

import UIKit

class ActivityTableViewController: UITableViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var weightSlider: UISlider!
    @IBOutlet weak var repSlider: UISlider!

    var activity: Activity?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        let dataManager = DataManager.sharedInstance
        if activity == nil {
            activity = dataManager.generateActivity()
        }
        activity!.name = nameTextField.text
        activity!.weight = NSDecimalNumber(value: weightSlider.value)
        activity!.repetitions = Int16(repSlider.value)
    }
}
