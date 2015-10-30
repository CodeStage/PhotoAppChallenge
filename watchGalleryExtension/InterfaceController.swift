//
//  InterfaceController.swift
//  watchGallery Extension
//
//  Created by Christian König on 27.10.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {

    @IBOutlet private weak var picker: WKInterfacePicker!
    private let store = StockPhotoStore()
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        var items: [WKPickerItem] = []
        for index in 0 ..< store.count {
            store.photoForIndex(index, completion: { (photo) -> () in
                let item = WKPickerItem()
                item.contentImage = WKImage.init(image: photo.image)
                items.append(item)
            })
        }
        picker.setItems(items)
    }
}
