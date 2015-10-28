

import Foundation
import UIKit


// Displays a singe photo and provides zoom functionality
class ImageScrollViewController: UIViewController, UIScrollViewDelegate {

    var imageView: UIImageView!
    var scrollView: UIScrollView {
        get {
            return view as! UIScrollView
        }
    }
    var imageConstraintTop: NSLayoutConstraint!
    var imageConstraintRight: NSLayoutConstraint!
    var imageConstraintLeft: NSLayoutConstraint!
    var imageConstraintBottom: NSLayoutConstraint!
    var lastZoomScale: CGFloat = -1
    var photo: Photo? {
        didSet {
            imageView.image = photo?.image
            updateZoom()
        }
    }
    var gestureRecognizer: UITapGestureRecognizer!
    
    
    override func loadView() {
        view = UIScrollView()
        imageView = UIImageView(frame: CGRectZero)
        view.addSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .ScaleAspectFill
        imageView.clipsToBounds = true
        
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.decelerationRate = UIScrollViewDecelerationRateNormal
        
        imageConstraintLeft = (NSLayoutConstraint.init(item: imageView, attribute: .Leading, relatedBy: .Equal, toItem: view, attribute: .Leading, multiplier: 1, constant: 0))
        imageConstraintRight = (NSLayoutConstraint.init(item: imageView, attribute: .Trailing, relatedBy: .Equal, toItem: view, attribute: .Trailing, multiplier: 1, constant: 0))
        imageConstraintTop = (NSLayoutConstraint.init(item: imageView, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1, constant: 0))
        imageConstraintBottom = (NSLayoutConstraint.init(item: imageView, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1, constant: 0))
        
        scrollView.addConstraints([imageConstraintLeft, imageConstraintRight, imageConstraintTop, imageConstraintBottom])
        
        gestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("handleTap:"))
        scrollView.addGestureRecognizer(gestureRecognizer)

    }

    // Update zoom scale and constraints with animation.
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
            super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
            coordinator.animateAlongsideTransition({ [weak self] _ in
                    self?.updateZoom()
                }, completion: nil)
    }
    
    func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .Ended {
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
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
    
    // Zoom to show as much image as possible unless image is smaller than the scroll view
    private func updateZoom() {
        if let image = imageView.image {
            let maxZoom = scrollView.bounds.size.height / image.size.height
            let minZoom = { () -> CGFloat in
                let smallestRatio = min(scrollView.bounds.size.width / image.size.width, scrollView.bounds.size.height / image.size.height)
                if smallestRatio > 1 { return 1 }
                return smallestRatio
            }()
            let optimalZoom = { () -> CGFloat in
                if self.scrollView.bounds.size.width > image.size.width {
                    return self.scrollView.bounds.size.width / image.size.height
                }
                else {
                    return self.scrollView.bounds.size.width / image.size.width
                }
            }()
            
            scrollView.minimumZoomScale = minZoom
            scrollView.maximumZoomScale = maxZoom
            scrollView.zoomScale = optimalZoom
            lastZoomScale = optimalZoom
            updateConstraints()
        }
    }
    
    func scrollViewDidZoom(scrollView: UIScrollView) {
        updateConstraints()
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
}

