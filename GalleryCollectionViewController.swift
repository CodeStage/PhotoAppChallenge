//
//  GalleryCollectionViewController.swift
//  Gallery
//
//  Created by Christian König on 27.10.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//

import Foundation
import UIKit


// Displays a collection of images and allows to zoom in on one
class GalleryCollectionViewController: UICollectionViewController {

    private let imageStore = ImageStore()
    private let layout = UICollectionViewFlowLayout()
    private let padding: CGFloat = 1 // Defines the padding around each cell

    
    init() {
        super.init(collectionViewLayout: layout)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView?.registerClass(GalleryCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: GalleryCollectionViewCell.identifier)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        configureLayout()
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imageStore.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: GalleryCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(GalleryCollectionViewCell.identifier, forIndexPath: indexPath) as! GalleryCollectionViewCell
        cell.image = imageStore.imageForIndex(indexPath.row)
        return cell
    }
    
    // Defines how many images should be displayed in one row
    private func numberOfCellsInRow() -> CGFloat {
        if self.traitCollection.userInterfaceIdiom == .TV { return 7 }
        if self.traitCollection.horizontalSizeClass == .Regular { return 5 }
        return 4
    }
    
    // Calculates the cell sizes and configures the layout accordingly
    private func configureLayout() {
        let itemWidth: CGFloat = self.view.frame.size.width / numberOfCellsInRow()
        layout.itemSize = CGSizeMake(itemWidth - padding, itemWidth - padding)
        layout.minimumInteritemSpacing = padding
        layout.minimumLineSpacing = padding
    }
    
}