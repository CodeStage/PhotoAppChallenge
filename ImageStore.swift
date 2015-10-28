//
//  ImageStore.swift
//  Gallery
//
//  Created by Christian König on 27.10.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//

import Foundation
import UIKit
import WatchKit

// To reduce the demo project size, the store pretends to have more images than the bundle actually contains.
class ImageStore {

    private var assets: [String]
    let assetNames = [
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
            return assets.count
        }
    }
    
    
    init() {
        assets = assetNames + assetNames + assetNames + assetNames
        assets.shuffleInPlace()
    }
    
    
    func imageForIndex(index: Int) -> UIImage? {
        guard let image = UIImage.init(named: self.assets[index]) else {
            print("Failed to load image named: \(self.assets[index])")
            return nil
        }
        return image
    }
    
    func images() -> [UIImage] {
        var images = [UIImage]()
        for index in 0 ..< self.count {
            if let image = self.imageForIndex(index) {
                images.append(image)
            }
        }
        return images
    }
}


extension MutableCollectionType where Index == Int {
    
    /// Shuffle the elements of `self` in-place.
    mutating func shuffleInPlace() {
        if count < 2 { return }
        for i in 0 ..< count - 1 {
            let j = Int(arc4random_uniform(UInt32(count - i))) + i
            guard i != j else { continue }
            swap(&self[i], &self[j])
        }
    }
}
