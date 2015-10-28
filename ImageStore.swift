//
//  ImageStore.swift
//  Gallery
//
//  Created by Christian König on 27.10.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//

import Foundation
import UIKit


// Provides stock photos delivered in the app bundle
class ImageStore {

    private let assets: [String] = [
        "6H", "79H", "89H", "8H", "4H", "74H", "44H", "39H", "21H", "12H",
        "185H", "193H", "195H", "197H", "198H", "201H", "206H", "208H", "219H", "225H",
        "226H", "234H", "235H", "237H", "239H", "243H", "244H", "245H", "123H", "129H",
        "147H", "149H", "157H", "165H", "177H", "119H", "160H",
    ]
    
    var count: Int {
        get {
            return assets.count
        }
    }
    
    func imageForIndex(index: Int) -> UIImage? {
        guard let image = UIImage.init(named: assets[index]) else {
            print("Failed to load image named: \(assets[index])")
            return nil
        }
        return image
    }
    
    func images() -> [UIImage] {
        var images = [UIImage]()
        for index in 0 ..< count {
            if let image = imageForIndex(index) {
                images.append(image)
            }
        }
        return images
    }
}

