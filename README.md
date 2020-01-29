# POFImageCollection
This is an application to download 5000 images and bind them to UI.

## Language:
- Swift

## Characteristics:
- Must scroll at 60fps.
- No off-Screen rending must occur.
- No UI blocking must occur.
- Images must be cached.
- No persistance for the first version.
- No dependencies.

## Design Pattern:
- Clean design pattern is used (View-Interactor-Presenter)

## Technologies:
- Prefetching API for collectionview.
- NSCache for caching strategy.
- Drawing rounded corner and shadow effect directly on image to avoid offscreen rendering.
- Autolayout.

## UI Elements:
- No xib/storyboard is used.
- CollectionView with custom layout.

## End Points:
- "https://jsonplaceholder.typicode.com/photos"
