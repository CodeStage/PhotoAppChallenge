//
//  GalleryCollectionViewController.swift
//  Gallery
//
//  Created by Christian König on 27.10.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//

import Foundation
import UIKit


class GalleryCollectionViewController: UICollectionViewController {

    private let imageStore = ImageStore()
    private let layout = UICollectionViewFlowLayout()

    init() {
        super.init(collectionViewLayout: layout)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView?.registerClass(GalleryCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "GalleryCollectionViewCell")
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        configureLayout()
    }
    
    private func numberOfCellsInRow() -> CGFloat {
        if self.traitCollection.userInterfaceIdiom == .TV { return 7 }
        if self.traitCollection.horizontalSizeClass == .Regular { return 5 }
        return 4
    }
    
    private func configureLayout() {
        let padding: CGFloat = 1
        let itemWidth: CGFloat = self.view.frame.size.width / numberOfCellsInRow()
        layout.itemSize = CGSizeMake(itemWidth - padding, itemWidth - padding)
        layout.scrollDirection = UICollectionViewScrollDirection.Vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0 , bottom: 0, right: 0)
        layout.minimumInteritemSpacing = padding
        layout.minimumLineSpacing = padding
        layout.scrollDirection = .Vertical
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imageStore.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: GalleryCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("GalleryCollectionViewCell", forIndexPath: indexPath) as! GalleryCollectionViewCell
        cell.image = nil
        imageStore.imageForIndex(indexPath.row) { (image) -> Void in
            cell.image = image
        }
        return cell
    }
    
}