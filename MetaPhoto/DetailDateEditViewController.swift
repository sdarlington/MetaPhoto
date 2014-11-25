//
//  DetailDateEditViewController.swift
//  MetaPhoto
//
//  Created by Stephen Darlington on 23/11/2014.
//  Copyright (c) 2014 Wandle Software Limited. All rights reserved.
//

import UIKit

protocol DetailDateEditDelegate {
    func detailDate(edit:DetailDateEditViewController, newDate:NSDate)
}

class DetailDateEditViewController: UIViewController {
    
    @IBOutlet var datePicker: UIDatePicker!
    
    var delegate:DetailDateEditDelegate?
    var dateFieldName:String?
    var dateValue:NSDate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let setDateValue = self.dateValue {
            self.datePicker.date = setDateValue
        }
    }
    
    @IBAction func tapCancelButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion:nil)
    }
    
    @IBAction func tapSaveDate(sender: AnyObject) {
        self.dateValue = self.datePicker.date
        if let del = self.delegate {
            self.delegate?.detailDate(self, newDate: self.datePicker.date)
        }
        self.dismissViewControllerAnimated(true, completion:nil)
    }
}
