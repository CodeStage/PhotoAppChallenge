

import Foundation
import UIKit


// Provides photos from the device
class DevicePhotoStore: PhotoProvider {
    
    var count: Int {
        get {
            return 0
        }
    }
    var selectedIndex: Int?
    

    func photoForIndex(index: Int) -> Photo? {

        return nil
    }
}

