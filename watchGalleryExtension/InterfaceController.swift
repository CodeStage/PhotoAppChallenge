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
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            self.loadPhotos()
        }
    }
    
    func loadPhotos() {
        let sem = dispatch_semaphore_create(0)
        var items: [WKPickerItem] = []
        
        // Since the API is designed to load one image at a time but the picker needs the items
        // all at once, we have to collect them and then pass them on
        for index in 0 ..< store.count {
            store.photoForIndex(index, completion: { (photo) -> () in
                let item = WKPickerItem()
                item.contentImage = WKImage.init(image: photo.image)
                items.append(item)
                dispatch_semaphore_signal(sem)
            })
        }
        
        for _ in 0 ..< store.count {
            dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER)
        }
        
        dispatch_async(dispatch_get_main_queue()) {
            self.picker.setItems(items)
        }
    }
}
