

import Foundation
import UIKit


// Provides stock photos from the app bundle
class StockPhotoStore: PhotoProvider {

    private let assets: [String] = [
        "6H", "79H", "89H", "8H", "4H", "74H", "44H", "39H", "21H", "12H",
        "185H", "193H", "195H", "197H", "198H", "201H", "206H", "208H", "219H", "225H",
        "226H", "234H", "235H", "237H", "210H", "243H", "244H", "245H", "123H", "129H",
        "147H", "149H", "157H", "165H", "177H", "119H", "160H", "163H", "167H", "168H",
        "170H", "174H", "196H", "181H", "186H", "199H", "204H", "209H", "239H", "217H",
        "224H", "227H", "228H", "240H",
    ]
    
    var count: Int {
        get {
            return assets.count
        }
    }
    var selectedIndex: Int?


    func photoForIndex(index: Int, completion: (photo: Photo) -> ()) -> () {
        guard index >= 0 else { return }
        guard index < count else { return }
        
        let name = assets[index]
        let image = UIImage.init(named: name)

        if let image = image {
            completion(photo: Photo(image: image, description: name))
        }
    }
    
    func photoForIndex(index: Int, targetSize: CGSize, completion: (photo: Photo) -> ()) -> () {
        return photoForIndex(index, completion: completion)
    }
}

