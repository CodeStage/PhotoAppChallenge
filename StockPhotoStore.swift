

import Foundation
import UIKit


// Provides stock photos from the app bundle
//
// Use count and photoForIndex() when working with large data sets,
// otherwise loading all photos at once with photos() is fine.
class StockPhotoStore: PhotoProvider {

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
    
    var selectedIndexPath: NSIndexPath? {
        didSet {
            print("selectedIndex: \(selectedIndexPath?.row)")
        }
    }
    
    func photoForIndex(index: Int) -> Photo? {
        guard index >= 0 else { return nil }
        guard index < count else { return nil }
        
        let name = assets[index]
        let image = UIImage.init(named: name)

        if let image = image {
            return Photo(image: image, description: name)
        }
        
        print("Failed to load image named: \(name)")
        return nil
    }
    
    func photos() -> [Photo] {
        var images = [Photo]()
        for index in 0 ..< count {
            if let photo = photoForIndex(index) {
                images.append(photo)
            }
        }
        return images
    }
}

