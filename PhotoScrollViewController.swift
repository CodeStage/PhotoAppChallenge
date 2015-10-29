

import Foundation
import UIKit


// Displays a singe photo and provides zoom functionality
class PhotoScrollViewController: UIViewController {

    private var singleTapRecognizer: UITapGestureRecognizer!
    private var imageView: UIImageView!
    private var scrollView: UIScrollView!
    private var textLabel: UILabel!

    private var imageConstraintTop: NSLayoutConstraint!
    private var imageConstraintRight: NSLayoutConstraint!
    private var imageConstraintLeft: NSLayoutConstraint!
    private var imageConstraintBottom: NSLayoutConstraint!
    private var lastZoomScale: CGFloat = -1
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
        
        view = UIView(frame: (UIApplication.sharedApplication().keyWindow?.bounds) ?? CGRectZero)
        view.autoresizesSubviews = true
        
        addScrollViewToRootView()
        addImageViewToScrollView()
        addTapRecognizerToScrollView()
        let background = addVibrancyViewToRootView(view)
        addLabelToRootView(background.contentView)
    }
    
    private func addVibrancyViewToRootView(rootView: UIView) -> UIVisualEffectView {

        let blurEffect = UIBlurEffect(style: .Light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(blurView)
        
        let vibrancyEffect = UIVibrancyEffect(forBlurEffect: blurEffect)
        let vibrancyView = UIVisualEffectView(effect: vibrancyEffect)
        vibrancyView.translatesAutoresizingMaskIntoConstraints = false
        blurView.contentView.addSubview(vibrancyView)
        
        let constraintLeft = (NSLayoutConstraint.init(item: blurView, attribute: .Leading, relatedBy: .Equal, toItem: view, attribute: .Leading, multiplier: 1, constant: 0))
        let constraintRight = (NSLayoutConstraint.init(item: blurView, attribute: .Trailing, relatedBy: .Equal, toItem: view, attribute: .Trailing, multiplier: 1, constant: 0))
//        let constraintTop = (NSLayoutConstraint.init(item: blurView, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1, constant: -20))
        let constraintBottom = (NSLayoutConstraint.init(item: blurView, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1, constant: 0))
        
        NSLayoutConstraint.activateConstraints([constraintLeft, constraintRight, constraintBottom])
        
        addConstraintsForViewFillingSuperview(vibrancyView, superView: blurView)
        return vibrancyView
    }
    
    private func addConstraintsForViewFillingSuperview(view: UIView, superView: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        let constraintLeft = (NSLayoutConstraint.init(item: view, attribute: .Leading, relatedBy: .Equal, toItem: superView, attribute: .Leading, multiplier: 1, constant: 0))
        let constraintRight = (NSLayoutConstraint.init(item: view, attribute: .Trailing, relatedBy: .Equal, toItem: superView, attribute: .Trailing, multiplier: 1, constant: 0))
        let constraintTop = (NSLayoutConstraint.init(item: view, attribute: .Top, relatedBy: .Equal, toItem: superView, attribute: .Top, multiplier: 1, constant: 0))
        let constraintBottom = (NSLayoutConstraint.init(item: view, attribute: .Bottom, relatedBy: .Equal, toItem: superView, attribute: .Bottom, multiplier: 1, constant: 0))
        NSLayoutConstraint.activateConstraints([constraintLeft, constraintRight, constraintBottom, constraintTop])
    }
    
    private func addLabelToRootView(rootView: UIView) {
        textLabel = UILabel()
        textLabel.textColor = UIColor.whiteColor()
        textLabel.textAlignment = .Center
        textLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        rootView.addSubview(textLabel)
        addConstraintsForViewFillingSuperview(textLabel, superView: rootView)
    }
    
    private func addScrollViewToRootView() {
        scrollView = UIScrollView(frame: (UIApplication.sharedApplication().keyWindow?.bounds) ?? CGRectZero)
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.decelerationRate = UIScrollViewDecelerationRateNormal
        view.addSubview(scrollView)
        addConstraintsForViewFillingSuperview(scrollView, superView: view)
    }
    
    private func addImageViewToScrollView() {
        imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .ScaleAspectFill
        imageView.clipsToBounds = true
        scrollView.addSubview(imageView)
        
        imageConstraintLeft = (NSLayoutConstraint.init(item: imageView, attribute: .Leading, relatedBy: .Equal, toItem: scrollView, attribute: .Leading, multiplier: 1, constant: 0))
        imageConstraintRight = (NSLayoutConstraint.init(item: imageView, attribute: .Trailing, relatedBy: .Equal, toItem: scrollView, attribute: .Trailing, multiplier: 1, constant: 0))
        imageConstraintTop = (NSLayoutConstraint.init(item: imageView, attribute: .Top, relatedBy: .Equal, toItem: scrollView, attribute: .Top, multiplier: 1, constant: 0))
        imageConstraintBottom = (NSLayoutConstraint.init(item: imageView, attribute: .Bottom, relatedBy: .Equal, toItem: scrollView, attribute: .Bottom, multiplier: 1, constant: 0))
        NSLayoutConstraint.activateConstraints([imageConstraintLeft, imageConstraintRight, imageConstraintTop, imageConstraintBottom])
    }
    
    private func addTapRecognizerToScrollView() {
        singleTapRecognizer = UITapGestureRecognizer(target: self, action: Selector("handleSingleTap:"))
        scrollView.addGestureRecognizer(singleTapRecognizer)
        scrollView.userInteractionEnabled = true
    }

    // Update zoom scale and constraints with animation
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
            super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
            coordinator.animateAlongsideTransition({ [weak self] _ in
                    self?.updateZoom()
                }, completion: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        if let index = index {
            photo = store.photoForIndex(index)
        }
    }
    
    func handleSingleTap(sender: UITapGestureRecognizer) {
        if sender.state == .Ended {
            dismissViewControllerAnimated(true, completion: nil)
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
            
            view.needsUpdateConstraints()
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

            let maxZoom = canvasHeight / photoHeight
            let minZoom = { () -> CGFloat in
                let smallest = min(canvasWidth / photoWidth, canvasHeight / photoHeight)
                if smallest > 1 { return 1 }
                return smallest
            }()
            let optimalZoom = { () -> CGFloat in
                if photoRatio > canvasRatio {
                    return canvasWidth / photoWidth
                }
                else {
                    return canvasHeight / photoHeight
                }
            }()

            scrollView.minimumZoomScale = minZoom
            scrollView.maximumZoomScale = maxZoom
            scrollView.zoomScale = optimalZoom
            lastZoomScale = optimalZoom
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

