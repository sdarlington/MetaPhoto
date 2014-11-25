//
//  ImageCollectionViewCell.swift
//  MetaPhoto
//
//  Created by Stephen Darlington on 21/11/2014.
//  Copyright (c) 2014 Wandle Software Limited. All rights reserved.
//

import UIKit
import Photos

@objc class ImageCollectionViewCell : UICollectionViewCell {
   
    @IBOutlet var imageView: UIImageView!
    
    var image : PHAsset! {
        didSet {
            var options = PHImageRequestOptions()
            options.deliveryMode = .Opportunistic
            options.resizeMode = .Fast
            
            self.requestID = PHImageManager.defaultManager().requestImageForAsset(self.image, targetSize: CGSizeMake(160.0, 160.0), contentMode: .AspectFill, options: options, resultHandler: {
                (newImage : UIImage!, _) in
                self.imageView.image = newImage
                self.requestID = nil
            })
        }
    }

    var requestID : PHImageRequestID?

    override func prepareForReuse() {
        if let concreteRequestID = requestID {
            PHImageManager.defaultManager().cancelImageRequest(concreteRequestID)
        }
        self.imageView.image = nil
    }
}
