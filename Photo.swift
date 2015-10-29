

import Foundation
import UIKit


// This is a class, so that photos can be passed around by reference
class Photo: NSObject {
    
    var image: UIImage
    var text: String?
    
    init(image: UIImage, description: String?) {
        self.image = image
        self.text = description
    }
}


// Supports different photo sources
protocol PhotoProvider {
    var count: Int { get }
    
    func photoForIndex(index: Int) -> Photo?
    func photos() -> [Photo]
}

