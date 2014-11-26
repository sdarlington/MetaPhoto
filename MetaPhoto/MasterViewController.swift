//
//  MasterViewController.swift
//  MetaPhoto
//
//  Created by Stephen Darlington on 21/11/2014.
//  Copyright (c) 2014 Wandle Software Limited. All rights reserved.
//

import UIKit
import Photos

class MasterViewController: UICollectionViewController {

    var detailViewController: DetailViewController? = nil
    
    var photos : PHFetchResult!

    override func viewWillAppear(animated:Bool) {
        super.viewWillAppear(animated)
        
        if let x = self.photos {
            // we don't need to go through this if we have a valid PHFetchResult object
            return
        }

        PHPhotoLibrary.requestAuthorization() {
            status in
            
            switch (status) {
            case .Authorized:
                let options =  PHFetchOptions()
                self.photos =  PHAsset.fetchAssetsWithMediaType(.Image, options: options)
                
                self.collectionView.reloadData()
            default:
                var errorDialog = UIAlertController(title:"Permissions", message:"You don't have permissions to view the photo library", preferredStyle:.Alert)
                errorDialog.addAction(UIAlertAction(title:"Cancel", style:.Cancel, handler:nil))
                errorDialog.addAction(UIAlertAction(title:"Open settings", style:.Default, handler:{
                    action in
                    UIApplication.sharedApplication().openURL(NSURL(string:UIApplicationOpenSettingsURLString)!)
                    return
                }))
                
                self.presentViewController(errorDialog, animated:true, completion:nil)
            }
        }
    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.collectionView.indexPathsForSelectedItems()?.first as? NSIndexPath {
                let object = photos.objectAtIndex(indexPath.row) as PHAsset
                let controller = (segue.destinationViewController as UINavigationController).topViewController as DetailViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Collection View

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        if let photos = self.photos {
            return 1
        }
        else {
            return 0
        }
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photos.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ImageCell", forIndexPath: indexPath) as ImageCollectionViewCell
        
        cell.image = self.photos.objectAtIndex(indexPath.row) as PHAsset
        
        return cell
    }
    
}

