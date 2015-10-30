
# Topcoder Macoun - iOS Photo App Challenge

The project contains only low-res stock photos and cannot access the camera roll, so it's best to demo on an iPhone 4S. It will run properly on watchOS, tvOS and iOS - supporting all iPad and iPhones running iOS 9.1. You need Xcode 7.1 to build and run it.

The stock photos are from <http://www.gratisography.com/terms.html> released under [Creative Commons Zero](http://creativecommons.org/publicdomain/zero/1.0/). The project does not contain third party frameworks or code.

## Components

The Gallery has 3 main components:

* The photo store
* The gallery view, implemented with as a collection view
* The single photo view, implemented with a scroll view and an image view with a label

On watchOS a picker control is used to display single photos, a gallery view is not feasible.

Making use of auto-layout, size classes and dynamic type, each component has only a single implementation that supports all platforms.

### The photo store
A photo is replesented by a `Photo` object, which contains the actual image and a description. `StockPhotoStore` provides a couple of low-res stock photos which the app can use without accessing the camera roll.

### The gallery view
`GalleryCollectionViewController` is the root view controller of the dem app. It uses `GalleryCollectionViewCell` to display miniaturised versions of the photos. Note that there is no offline optimization, so using a very large number of photos might raise performance issues. Tapping one of the cells - or selecting one with the TV remote - will show the select image modally.

### The single photo view
When looking at a single photo the `PhotoPageViewController` allows swiping left or right to show the next picture, tapping - or pressing the menu button - will go back to the gallery view. The `PhotoScrollViewController` nested inside allows zooming in and out and scrolling the photo.

## Deployment
Firtst you have to select the scheme for the platform you want to run the demo on and which simulator you want to run it in. There are 3 shared schemes: 

* tvGallery for watchOS
* iGallery for iOS (iPhone, iPad)
* watchGallery for Apple Watch

After that you should be able to build and run the demo app.

For deploying on devices you might have to change the Bundle Identifier and make sure that Xcode is set up correctly for signing.

## About
My name is Christian König, I'm an independent iOS devopler from Germany. You can find me on Twitter as @CodeStage
