//
//  iGalleryTests.swift
//  iGalleryTests
//
//  Created by Christian König on 30.10.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//

import XCTest
import UIKit


class iGalleryTests: XCTestCase {
    
    func testThatStockPhotoStoreProvidesPhotos() {
        let store = StockPhotoStore()
        
        XCTAssertGreaterThan(store.count, 0, "The store could not load any photos. Maybe the are not contained in the app bundle?")
        
        for index in 0 ..< store.count {
            if let photo = store.photoForIndex(index) {
                let image = photo.image
                XCTAssertGreaterThan(image.size.width, 0, "Image width should be greater than 0")
                XCTAssertGreaterThan(image.size.height, 0, "Image height should be greater than 0")
            }
            else {
                XCTFail("The store did not provide a photo for index: \(index)")
            }
        }
    }
}
