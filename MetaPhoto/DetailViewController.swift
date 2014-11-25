//
//  DetailViewController.swift
//  MetaPhoto
//
//  Created by Stephen Darlington on 21/11/2014.
//  Copyright (c) 2014 Wandle Software Limited. All rights reserved.
//

import UIKit
import Photos

class DetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, DetailDateEditDelegate {

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var tableView: UITableView!

    enum EditableValueType : Int {
        case EditableValueTypeDate
        case EditableValueTypeBool
    }
    
    let editableValues = [ ("creationDate", EditableValueType.EditableValueTypeDate), ("modificationDate", EditableValueType.EditableValueTypeDate), ("favorite", EditableValueType.EditableValueTypeBool), ("hidden", EditableValueType.EditableValueTypeBool) ]
    
    var detailItem: PHAsset? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }

    var requestID : PHImageRequestID?

    func configureView() {
        if let a = self.imageView {
            var options = PHImageRequestOptions()
            options.deliveryMode = .Opportunistic
            options.resizeMode = .Fast
            
            self.requestID = PHImageManager.defaultManager().requestImageForAsset(self.detailItem, targetSize: CGSizeMake(self.imageView.frame.size.width, self.imageView.frame.size.height), contentMode: .AspectFill, options: options, resultHandler: {
                (newImage : UIImage!, _) in
                self.imageView.image = newImage
                self.requestID = nil
            })
        }

    }
    
    func changeImageMetaDataKey(key:String, value:AnyObject) {
        self.detailItem!.setValue(value, forKey:key)

        PHPhotoLibrary.sharedPhotoLibrary().performChanges({
            var change = PHAssetChangeRequest(forAsset:self.detailItem)
            change.setValue(value, forKey:key)
            },
            completionHandler:{
                success, error in
                if let realError = error {
                    var errorDialog = UIAlertController(title:"Couldn't update",
                        message:realError.localizedDescription,
                        preferredStyle:.Alert )
                    errorDialog.addAction(UIAlertAction(title:"Oh dear!", style:.Cancel, handler:nil))
                    
                    self.presentViewController(errorDialog, animated:true, completion:nil)
                }
        })

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
    }

    // can't override dealloc, so I guess this will have to do
    override func viewDidDisappear(animated:Bool) {
        super.viewDidDisappear(animated)
        if let a = self.requestID {
            PHImageManager.defaultManager().cancelImageRequest(a)
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "editDateSegue" {
            let indexPath = self.tableView.indexPathForSelectedRow()
            let (text,type) = editableValues[indexPath!.row]

            var dateEdit = segue.destinationViewController as DetailDateEditViewController
            let theDate = self.detailItem!.valueForKeyPath(text) as NSDate
            dateEdit.dateValue = theDate
            dateEdit.dateFieldName = text
            dateEdit.delegate = self
        }
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return editableValues.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let (text,type) = editableValues[indexPath.row]
        
        var cell:UITableViewCell!
        switch (type) {
        case EditableValueType.EditableValueTypeDate:
            var newCell = tableView.dequeueReusableCellWithIdentifier("DateCell") as DetailDateCell
            newCell.textLabel.text = text
            let theDate = self.detailItem!.valueForKeyPath(text) as NSDate
            newCell.detailTextLabel!.text = theDate.description
            
            cell = newCell
        case EditableValueType.EditableValueTypeBool:
            var newCell = tableView.dequeueReusableCellWithIdentifier("BoolCell") as DetailBoolCell
            newCell.textLabel.text = text
            let theValue = self.detailItem!.valueForKeyPath(text) as Bool
            newCell.detailTextLabel!.text = theValue.description
            
            cell = newCell
        default:
            var newCell = UITableViewCell(style:.Subtitle, reuseIdentifier:"cell")
            newCell.detailTextLabel!.text = "Dunno"
            
            cell = newCell
        }
        
        return cell!
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let (text,type) = editableValues[indexPath.row]
        switch (type) {
        case EditableValueType.EditableValueTypeBool:
            let currentvalue = self.detailItem!.valueForKeyPath(text) as NSNumber
            let currentBoolValue = currentvalue.boolValue
            self.changeImageMetaDataKey(text, value: !currentBoolValue)
            
            tableView.reloadRowsAtIndexPaths([ indexPath ], withRowAnimation:.Automatic)
            self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        default:
            // no nothing
            break
        }
        
    }
    
    // MARK: - DetailDateEditDelegate
    
    func detailDate(edit: DetailDateEditViewController, newDate: NSDate) {
       let indexPath = self.tableView.indexPathForSelectedRow()
        if let selectedIndexPath = indexPath {
            let (text,type) = editableValues[selectedIndexPath.row]
            self.changeImageMetaDataKey(text, value: newDate)
            tableView.reloadRowsAtIndexPaths([ selectedIndexPath ], withRowAnimation:.Automatic)
            self.tableView.deselectRowAtIndexPath(selectedIndexPath, animated: true)
        }
    }
    
}

