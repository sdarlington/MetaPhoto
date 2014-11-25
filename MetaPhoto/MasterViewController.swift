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

    override func awakeFromNib() {
        super.awakeFromNib()

        // TODO: should check permissions before accessing photo library
        let options =  PHFetchOptions()
        self.photos =  PHAsset.fetchAssetsWithMediaType(.Image, options: options)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

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
        return 1
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

