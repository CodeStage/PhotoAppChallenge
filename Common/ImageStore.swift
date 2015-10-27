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
    
    private let assets = [
        "dt151021",
        "dt151022",
        "dt151023",
        "dt151024",
        "dt151026",
        "dt151027",
    ]
    
    var count: Int {
        get {
            return assets.count * 10
        }
    }
    
    func imageForIndex(index: Int) -> UIImage? {
        return UIImage.init(named: assets[index / 10])
    }
}