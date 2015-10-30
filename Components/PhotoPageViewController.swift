

import UIKit


// Displays a single photo and provides browsing functionality utilizing pages
class PhotoPageViewController: UIPageViewController {
    
    private var store: PhotoProvider!
    private var startIndex: Int = 0
    private var singleTapRecognizer: UITapGestureRecognizer!
    
    
    init(photoProvider: PhotoProvider, startIndex: Int?) {
        super.init(transitionStyle: UIPageViewControllerTransitionStyle.Scroll, navigationOrientation: UIPageViewControllerNavigationOrientation.Horizontal, options: nil)
        
        self.store = photoProvider
        if let startIndex = startIndex {
            self.startIndex = startIndex
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        singleTapRecognizer = UITapGestureRecognizer(target: self, action: Selector("handleSingleTap:"))
        view.backgroundColor = UIColor.blackColor()
        view.addGestureRecognizer(singleTapRecognizer)
        
        dataSource = self
        let initialViewController = PhotoScrollViewController.init(provider: store, index: startIndex)
        setViewControllers([initialViewController], direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        
        // This discards already initialized but invisible controllers, which will not be notified on size changes.
        // When rotating the device, this would lead to an incorrect layout of the controller before and after the current one.
        setViewControllers(viewControllers, direction: .Forward, animated: false, completion: nil)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    func handleSingleTap(sender: UITapGestureRecognizer) {
        if sender.state == .Ended {
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
}


extension PhotoPageViewController: UIPageViewControllerDataSource {

    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = (viewController as! PhotoScrollViewController).index else { return nil }
        guard currentIndex > 0 else { return nil }
        
        return PhotoScrollViewController.init(provider: store, index: currentIndex - 1)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = (viewController as! PhotoScrollViewController).index else { return nil }
        guard currentIndex < store.count - 1 else { return nil }
        
        return PhotoScrollViewController.init(provider: store, index: currentIndex + 1)
    }
}




