//
//  AddExpenceViewController.swift
//  mShare
//
//  Created by Manikandan V. Nair on 17/01/18.
//  Copyright © 2018 MVN. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import DynamicBlurView


class AddExpenceViewController: UIViewController, UIGestureRecognizerDelegate {
    
    let Calender  = 1
    let GroupButton = 2
    let Camera = 3
    let Voice = 4
    
    let common = Common()
   

    @IBOutlet weak var splitButton: UIButton!
    @IBOutlet weak var paidButton: UIButton!
    @IBOutlet weak var currencyButton: UIButton!
    @IBOutlet weak var expenceImageView: UIImageView!
    @IBOutlet weak var descriptionTextField: SkyFloatingLabelTextField!
    
    @IBOutlet weak var noteTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var amountTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var datePickerView: UIView!
    @IBOutlet weak var groupButton: UIButton!
    @IBOutlet weak var calenderButton: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var blurView:DynamicBlurView?
    var selectedGroup:Group!
    
    // MARK: - View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePickerView.isHidden = true
        setFont()
        

        // Do any additional setup after loading the view.
    }
    
    // MARK: - Actions

    @IBAction func splitButtonClick(_ sender: Any) {
    }
    
    @IBAction func paidButtonClick(_ sender: Any) {
        if (blurView == nil)
        {
            blurView = common.getBlurEffectView(view: self.view)
        }
        let memberListView = PaidView(group: selectedGroup , view: self.view)
        memberListView.didSelectedItem = { (selectedItem ) in
            
            self.paidButton.setTitle(selectedItem.name, for: .normal)
            memberListView.removeFromSuperview()
            self.blurView?.removeFromSuperview()
        }
        UIView.animate(withDuration: 0.5) {
            self.blurView!.blurRadius = 30
        }
        self.view.addSubview(blurView!)
        self.view.addSubview(memberListView)
    }
    
    @IBAction func currencyButtonClick(_ sender: Any) {
        
        if (blurView == nil)
        {
            blurView = common.getBlurEffectView(view: self.view)
        }
        let listView = CurrencySelector(view: self.view)
        listView.didSelectedItem = { (selectedItem ) in
            
            self.currencyButton.setTitle(selectedItem.symbol, for: .normal)
            self.currencyButton.tag = selectedItem.id
            listView.removeFromSuperview()
            self.blurView?.removeFromSuperview()
        }
        UIView.animate(withDuration: 0.5) {
            self.blurView!.blurRadius = 30
        }
        self.view.addSubview(blurView!)
        self.view.addSubview(listView)
        
    }
    
    @IBAction func onTapView(_ sender: Any) {
        datePickerView.isHidden = true
        self.view.endEditing(true)
    }
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
   
    
    @IBAction func backButtonClick(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func toolbarButtonClick(_ sender: Any) {
        let btn = sender as! UIButton
        let tag = btn.tag
        
        switch tag {
        case Calender:
            self.view.endEditing(true)
            self.datePickerView.isHidden = false
            self.view.bringSubview(toFront: self.datePickerView)
            
            break;
        
        default: break
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Fucntions
    
    func setFont()
    {
        noteTextField.titleLabel.font = FontForTextField
        noteTextField.placeholderFont = FontForTextField
        
        amountTextField.titleLabel.font = FontForTextField
        amountTextField.placeholderFont = FontForTextField
        
        descriptionTextField.titleLabel.font = FontForTextField
        descriptionTextField.placeholderFont = FontForTextField
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
