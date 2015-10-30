

import Foundation
import UIKit


// Displays a collection of images and allows to zoom in on one
class GalleryCollectionViewController: UICollectionViewController {

    private let store = StockPhotoStore()
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
        collectionView?.registerClass(GalleryCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: GalleryCollectionViewCell.identifier)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        configureLayout()
    }
    
    // Defines how many images should be displayed in one row
    private func numberOfCellsInRow() -> CGFloat {
        if traitCollection.userInterfaceIdiom == .TV { return 7 }
        if traitCollection.horizontalSizeClass == .Regular { return 5 }
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


extension GalleryCollectionViewController {

    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return store.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: GalleryCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(GalleryCollectionViewCell.identifier, forIndexPath: indexPath) as! GalleryCollectionViewCell
        cell.image = store.photoForIndex(indexPath.row)?.image
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let detailViewController = PhotoPageViewController.init(photoProvider: store, startIndex: indexPath.row)
        detailViewController.modalTransitionStyle = .CrossDissolve
        presentViewController(detailViewController, animated: true, completion: nil)
    }
    
    override func collectionView(collectionView: UICollectionView, canFocusItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        if let selectedIndexPath = store.selectedIndexPath {
            return selectedIndexPath.row == indexPath.row
        }
        return true
    }
    
    override func didUpdateFocusInContext(context: UIFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator) {
        store.selectedIndexPath = nil
    }
}

