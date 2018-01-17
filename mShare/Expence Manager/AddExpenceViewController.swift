//
//  AddExpenceViewController.swift
//  mShare
//
//  Created by Manikandan V. Nair on 17/01/18.
//  Copyright © 2018 MVN. All rights reserved.
//

import UIKit

class AddExpenceViewController: UIViewController {
    
    let Calender  = 1
    let GroupButton = 2
    let Camera = 3
    let Voice = 4

    @IBOutlet weak var groupButton: UIButton!
    @IBOutlet weak var calenderButton: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.isHidden = true

        // Do any additional setup after loading the view.
    }
    
    // MARK: - Actions


    
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        let selectedDate = sender.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let stringDate = dateFormatter.string(from: selectedDate)
        
        
        let currentDate = Date()
        if (stringDate == dateFormatter.string(from: currentDate))
        {
            calenderButton.setTitle("Today", for: .normal)
        }
        else
        {
            calenderButton.setTitle(stringDate, for: .normal)
        }
        
        
        
    }
   
    

    @IBAction func toolbarButtonClick(_ sender: Any) {
        let btn = sender as! UIButton
        let tag = btn.tag
        
        switch tag {
        case Calender:
            datePicker.isHidden = false
            break;
        default: break
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
