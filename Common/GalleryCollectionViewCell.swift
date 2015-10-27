//
//  GalleryCollectionViewCell.swift
//  Gallery
//
//  Created by Christian König on 27.10.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//

import Foundation
import UIKit


class GalleryCollectionViewCell: UICollectionViewCell {
    
    private var imageView: UIImageView
    
    required init?(coder aDecoder: NSCoder) {
        imageView = UIImageView.init(coder: aDecoder)!
        super.init(coder: aDecoder)
        configureLayout()
    }
    
    override init(frame: CGRect) {
        imageView = UIImageView.init(frame: frame)
        super.init(frame: frame)
        configureLayout()
    }
    
    func configureLayout() {
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .ScaleAspectFill
        addConstraint(NSLayoutConstraint.init(item: imageView, attribute: .Leading, relatedBy: .Equal, toItem: self, attribute: .Leading, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint.init(item: imageView, attribute: .Trailing, relatedBy: .Equal, toItem: self, attribute: .Trailing, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint.init(item: imageView, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint.init(item: imageView, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1, constant: 0))
    }
    
    var image: UIImage? {
        get {
            return imageView.image
        }
        set {
            imageView.image = newValue
        }
    }
    
}