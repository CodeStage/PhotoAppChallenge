

import UIKit


// Displays a single photo and provides browsing functionality utilizing pages
class PhotoPageViewController: UIPageViewController {
    
    private var store: PhotoProvider!
    private var startIndex: Int = 0
    
    
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

        dataSource = self
        let initialViewController = PhotoScrollViewController.dequeReusableController(store, index: startIndex)
        setViewControllers([initialViewController], direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
    }
}


extension PhotoPageViewController: UIPageViewControllerDataSource {

    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = (viewController as! PhotoScrollViewController).index else { return nil }
        guard currentIndex > 0 else { return nil }
        
        return PhotoScrollViewController.dequeReusableController(store, index: currentIndex - 1)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = (viewController as! PhotoScrollViewController).index else { return nil }
        guard currentIndex < store.count - 1 else { return nil }
        
        return PhotoScrollViewController.dequeReusableController(store, index: currentIndex + 1)
    }
}




