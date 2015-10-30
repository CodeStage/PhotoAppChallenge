

import Foundation
import UIKit
import Photos


// Provides photos from the device, but does only work on iPhones and iPads
class DevicePhotoStore: PhotoProvider {
    
    let dateFormatter = NSDateFormatter()
    let imageManager = PHImageManager()
    var assets: [PHAsset] = []
    
    var count: Int {
        get {
            return assets.count
        }
    }
    var selectedIndex: Int?
    
    
    init() {
        let options = PHFetchOptions()
        options.sortDescriptors = [
            NSSortDescriptor(key: "creationDate", ascending: false)
        ]
        let results = PHAsset.fetchAssetsWithMediaType(.Image, options: options)
        results.enumerateObjectsUsingBlock { (object, _, _) in
            if let asset = object as? PHAsset {
                self.assets.append(asset)
            }
        }
    }
    
    func photoForIndex(index: Int, completion: (photo: Photo) -> ()) -> () {
        return photoForIndex(index, targetSize: PHImageManagerMaximumSize, completion: completion)
    }
    
    func photoForIndex(index: Int, targetSize: CGSize, completion: (photo: Photo) -> ()) -> () {
        imageManager.requestImageForAsset(assets[index], targetSize: targetSize, contentMode: .AspectFill, options: nil) {
            image, info in
            if let image = image {
                var description: String?
                if let date = self.assets[index].creationDate {
                    description = NSDateFormatter.localizedStringFromDate(date, dateStyle: .LongStyle, timeStyle: .NoStyle)
                }
                
                let photo = Photo(image: image, description: description)
                completion(photo: photo)
            }
        }
    }
}

