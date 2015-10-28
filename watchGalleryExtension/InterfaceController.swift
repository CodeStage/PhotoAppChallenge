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
    private let imageStore = ImageStore()
    
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        var items: [WKPickerItem] = []
        for image in imageStore.images() {
            let item = WKPickerItem()
            item.contentImage = WKImage.init(image: image)
            items.append(item)
        }
        picker.setItems(items)
    }
}
