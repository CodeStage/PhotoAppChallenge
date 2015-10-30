

import Foundation
import UIKit


// Displays a singe photo and provides zoom functionality
class PhotoScrollViewController: UIViewController {

    private var imageView: UIImageView!
    private var scrollView: UIScrollView!
    private var textLabel: UILabel!
    private var imageConstraintTop: NSLayoutConstraint!
    private var imageConstraintRight: NSLayoutConstraint!
    private var imageConstraintLeft: NSLayoutConstraint!
    private var imageConstraintBottom: NSLayoutConstraint!
    private var photo: Photo? {
        didSet {
            if let _photo = photo {
                imageView.image = _photo.image
                textLabel.text = _photo.text
                updateZoom()
            }
            else {
                imageView.image = nil
            }
        }
    }
    private var store: PhotoProvider!
    var index: Int?
    
    
    init(provider: PhotoProvider, index: Int?) {
        self.store = provider
        self.index = index
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // Create and configure subviews and layout
    override func loadView() {
        let estimatedInitialSize = (UIApplication.sharedApplication().keyWindow?.bounds) ?? CGRectZero
        view = UIView(frame: estimatedInitialSize)
        view.autoresizesSubviews = true
        
        scrollView = UIScrollView(frame: estimatedInitialSize)
        configurePhotoScrollView(scrollView, superView: view)
        
        imageView = UIImageView()
        configureImageView(imageView, superView: scrollView)

        textLabel = UILabel()
        configureLabel(textLabel, superView: imageView)
    }

    // Update zoom scale and constraints with animation
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
            super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
            coordinator.animateAlongsideTransition({ [weak self] _ in
                    self?.updateZoom()
                }, completion: nil)
    }
    
    // Load the image into the view and save the current index for later (it's needed to restore the focus in the overview)
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        if let index = index {
            photo = store.photoForIndex(index)
            store.selectedIndex = index
        }
    }
    
    // Update size and position of the image depending on the current zoom scale
    private func updateConstraints() {
        if let image = imageView.image {
            let imageWidth = image.size.width
            let imageHeight = image.size.height
            let viewWidth = scrollView.bounds.size.width
            let viewHeight = scrollView.bounds.size.height
            
            // Center image if it is smaller than the scroll view
            var hPadding = (viewWidth - scrollView.zoomScale * imageWidth) / 2
            if hPadding < 0 { hPadding = 0 }
            var vPadding = (viewHeight - scrollView.zoomScale * imageHeight) / 2
            if vPadding < 0 { vPadding = 0 }
            
            imageConstraintLeft.constant = hPadding
            imageConstraintRight.constant = hPadding
            imageConstraintTop.constant = vPadding
            imageConstraintBottom.constant = vPadding
            view.layoutIfNeeded()
        }
    }
    
    // Calculate optimal zoom scale to show as much image as possible unless image is smaller than the scroll view
    private func updateZoom() {
        if let image = imageView.image {
            let canvasWidth = scrollView.bounds.size.width
            let canvasHeight = scrollView.bounds.size.height
            let photoWidth = image.size.width
            let photoHeight = image.size.height
            let photoRatio = photoWidth / photoHeight
            let canvasRatio = canvasWidth / canvasHeight

            let maxScale =  6 / UIScreen.mainScreen().scale
            let minScale = { () -> CGFloat in
                let smallest = min(canvasWidth / photoWidth, canvasHeight / photoHeight)
                if smallest > 1 { return 1 }
                return smallest
            }()
            let optimalScale = { () -> CGFloat in
                if photoRatio > canvasRatio {
                    return canvasWidth / photoWidth
                }
                else {
                    return canvasHeight / photoHeight
                }
            }()

            scrollView.minimumZoomScale = minScale
            scrollView.maximumZoomScale = maxScale
            scrollView.zoomScale = optimalScale
            updateConstraints()
        }
    }
}


extension PhotoScrollViewController: UIScrollViewDelegate {
    
    func scrollViewDidZoom(scrollView: UIScrollView) {
        updateConstraints()
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}


// Auto-Layout configuration
extension PhotoScrollViewController {

    private func activateConstraintsForViewFillingSuperView(superView: UIView, view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        let constraintLeft = (NSLayoutConstraint.init(item: view, attribute: .Leading, relatedBy: .Equal, toItem: superView, attribute: .Leading, multiplier: 1, constant: 0))
        let constraintRight = (NSLayoutConstraint.init(item: view, attribute: .Trailing, relatedBy: .Equal, toItem: superView, attribute: .Trailing, multiplier: 1, constant: 0))
        let constraintTop = (NSLayoutConstraint.init(item: view, attribute: .Top, relatedBy: .Equal, toItem: superView, attribute: .Top, multiplier: 1, constant: 0))
        let constraintBottom = (NSLayoutConstraint.init(item: view, attribute: .Bottom, relatedBy: .Equal, toItem: superView, attribute: .Bottom, multiplier: 1, constant: 0))
        NSLayoutConstraint.activateConstraints([constraintLeft, constraintRight, constraintBottom, constraintTop])
    }
    
    private func configurePhotoScrollView(scrollView: UIScrollView, superView: UIView) {
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.decelerationRate = UIScrollViewDecelerationRateNormal
        view.addSubview(scrollView)
        activateConstraintsForViewFillingSuperView(superView, view: scrollView)
    }
    
    private func configureImageView(imageView: UIImageView, superView: UIView) {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .ScaleAspectFill
        imageView.clipsToBounds = true
        superView.addSubview(imageView)
        imageConstraintLeft = (NSLayoutConstraint.init(item: imageView, attribute: .Leading, relatedBy: .Equal, toItem: superView, attribute: .Leading, multiplier: 1, constant: 0))
        imageConstraintRight = (NSLayoutConstraint.init(item: imageView, attribute: .Trailing, relatedBy: .Equal, toItem: superView, attribute: .Trailing, multiplier: 1, constant: 0))
        imageConstraintTop = (NSLayoutConstraint.init(item: imageView, attribute: .Top, relatedBy: .Equal, toItem: superView, attribute: .Top, multiplier: 1, constant: 0))
        imageConstraintBottom = (NSLayoutConstraint.init(item: imageView, attribute: .Bottom, relatedBy: .Equal, toItem: superView, attribute: .Bottom, multiplier: 1, constant: 0))
        NSLayoutConstraint.activateConstraints([imageConstraintLeft, imageConstraintRight, imageConstraintTop, imageConstraintBottom])
    }
    
    private func configureLabel(label: UILabel, superView: UIView) {
        let blurEffect = UIBlurEffect(style: .Light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        superView.addSubview(blurView)
        
        let constraintLeft = (NSLayoutConstraint.init(item: blurView, attribute: .Leading, relatedBy: .Equal, toItem: superView, attribute: .Leading, multiplier: 1, constant: 0))
        let constraintRight = (NSLayoutConstraint.init(item: blurView, attribute: .Trailing, relatedBy: .Equal, toItem: superView, attribute: .Trailing, multiplier: 1, constant: 0))
        let constraintBottom = (NSLayoutConstraint.init(item: blurView, attribute: .Bottom, relatedBy: .Equal, toItem: superView, attribute: .Bottom, multiplier: 1, constant: 0))
        NSLayoutConstraint.activateConstraints([constraintLeft, constraintRight, constraintBottom])
        
        let vibrancyEffect = UIVibrancyEffect(forBlurEffect: blurEffect)
        let vibrancyView = UIVisualEffectView(effect: vibrancyEffect)
        vibrancyView.translatesAutoresizingMaskIntoConstraints = false
        blurView.contentView.addSubview(vibrancyView)
        activateConstraintsForViewFillingSuperView(blurView, view: vibrancyView)
        
        textLabel.textColor = UIColor.whiteColor()
        textLabel.textAlignment = .Center
        textLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        vibrancyView.contentView.addSubview(textLabel)
        activateConstraintsForViewFillingSuperView(vibrancyView, view: textLabel)
    }
}



