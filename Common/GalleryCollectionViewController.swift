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
        
        self.collectionView?.registerNib(UINib.init(nibName: "GalleryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "GalleryCollectionViewCell")
        configureLayout()
    }
    
    func configureLayout() {
        let numberOfCellsInRow: CGFloat = 4
        let itemWidth = self.view.frame.size.width / numberOfCellsInRow
        layout.itemSize = CGSizeMake(itemWidth - 2, itemWidth - 2)
        layout.scrollDirection = UICollectionViewScrollDirection.Vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0 , bottom: 0, right: 0)
        layout.minimumInteritemSpacing = 2
        layout.minimumLineSpacing = 2
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imageStore.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: GalleryCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("GalleryCollectionViewCell", forIndexPath: indexPath) as! GalleryCollectionViewCell
        cell.image = imageStore.imageForIndex(indexPath.row)
        return cell
    }
    
}