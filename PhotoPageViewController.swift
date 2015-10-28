

import UIKit


// Displays a single photo and provides scrolling functionality (pages)
class PageViewController: UIPageViewController {
    
    private let controllers = [ImageScrollViewController(), ImageScrollViewController(), ImageScrollViewController(), ImageScrollViewController(), ImageScrollViewController()]
    private let photoProvider = StockPhotoStore()
    private let queue = NSOperationQueue()
    
    private var page: Int = 0 {
        didSet {
            print("page: \(page)")
        }
    }
    private var nextPage: Int = 0
    private var photos: [Photo] = []
    
    
    init() {
        super.init(transitionStyle: UIPageViewControllerTransitionStyle.Scroll, navigationOrientation: UIPageViewControllerNavigationOrientation.Horizontal, options: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        self.delegate = self
        self.setViewControllers([controllers[0]], direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
        
        photos = photoProvider.photos()
        
        // TODO: Start with specific photo
        self.controllers.first?.photo = photos.first
    }
    
    
    private func calculateOffsetForTransitionToController(nextController: ImageScrollViewController) -> Int {
        let offset = calculateOffsetForTransitionCounterFromCurrentIndex(self.page % self.controllers.count, nextIndex: self.controllers.indexOf(nextController)!, largestPossibleIndex: self.controllers.count - 1)
        return offset
    }
    
    private func calculateOffsetForTransitionCounterFromCurrentIndex(currrentIndex: Int, nextIndex: Int, largestPossibleIndex: Int) -> Int {
        if currrentIndex == largestPossibleIndex && nextIndex == 0 {
            return 1
        }
        if currrentIndex == 0 && nextIndex == largestPossibleIndex {
            return -1
        }
        if nextIndex > currrentIndex {
            return 1
        }
        else
        {
            return -1
        }
    }
}


extension PageViewController: UIPageViewControllerDataSource {

    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        if page == 0 {
            return nil
        }
        let prevIndex = (page - 1) % controllers.count
        print("prevIndex: \(prevIndex)")
        return controllers[prevIndex]
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        let nextIndex = (page + 1) % controllers.count
        print("nextIndex: \(nextIndex)")
        return controllers[nextIndex]
    }
}


extension PageViewController: UIPageViewControllerDelegate {
    
    func pageViewController(pageViewController: UIPageViewController, willTransitionToViewControllers pendingViewControllers: [UIViewController]) {
        let nextController = pendingViewControllers.first as! ImageScrollViewController
        nextController.photo = nil
        
        let offset = calculateOffsetForTransitionToController(nextController)
        self.nextPage = page + offset
        
        print("transition")
        nextController.photo = photos[nextPage]
    }
    
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            self.page = self.nextPage
        }
        else
        {
            print("transition cancelled")
        }
    }
}
