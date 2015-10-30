

import Foundation
import UIKit


// This is a class by design and not a struct, so that photos can be passed around by reference
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
    var count: Int { get } // Total number of photos in the store
    var selectedIndex: Int? { get set } // Can store which photo is selected
    
    func photoForIndex(index: Int, completion: (photo: Photo) -> ()) -> ()
    func photoForIndex(index: Int, targetSize: CGSize, completion: (photo: Photo) -> ()) -> ()
}

