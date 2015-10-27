//
//  ImageStore.swift
//  Gallery
//
//  Created by Christian König on 27.10.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//

import Foundation
import UIKit

class ImageStore {

    private let queue =  NSOperationQueue()
    private let assets = [
        "185H",
        "193H",
        "195H",
        "197H",
        "198H",
        "201H",
        "206H",
        "208H",
        "219H",
        "225H",
        "226H",
        "234H",
        "235H",
        "237H",
        "239H",
        "243H",
        "244H",
        "245H",
    ]
    
    var count: Int {
        get {
            return assets.count * 4
        }
    }
    
    func imageForIndex(index: Int, completion: (image: UIImage?) -> Void) {
//        queue.addOperationWithBlock { () -> Void in
            let image = UIImage.init(named: self.assets[random() % self.assets.count])
//            NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in
                completion(image: image)
//            }
//        }
    }
    
}