# 🖼️ Image Gallery App

A lightweight Swift app for browsing, caching, and viewing images — built as part of the Battlebucks assignment.

### 🚀 Build Instructions

Clone the repo:
~~~
git clone https://github.com/18kdr/Image-Gallery.git
cd Image-Gallery


Open in Xcode (.xcodeproj or .xcworkspace).

Select a simulator or device → Run (⌘R).

Requires Xcode 13+, iOS 15+, and Swift 5+.
~~~
### 🧩 Architecture Summary
~~~
Pattern: MVVM (Model–View–ViewModel)

Networking: URLSession using async/await for image fetching.

Caching: Custom in-memory + disk caching for offline access.

UI: SwiftUI views with pull-to-refresh and lazy loading.

Data Flow:
View → ViewModel → Service → Model → View (updates asynchronously)

Views/           → SwiftUI Screens  
ViewModels/      → Business Logic  
Services/        → Networking + Caching  
Models/          → Data Structures  
~~~
### 💭 Assumptions
~~~
Public API or open image URLs (no authentication).

Stable network during first fetch

Image count moderate (< 500) for smooth scrolling.

Designed primarily for iPhone, adaptive for iPad.
~~~
### ⚙️ Key Design Decisions
~~~
MVVM + async/await: Clean separation and responsive UI.

Custom cache: Avoids redundant downloads and supports offline access.

Minimal dependencies: Built using native Swift frameworks only.

Error handling: Graceful fallback with retry support.

Scalable layout: Grid adapts to device size/orientation.
~~~

### Future scope: upload support, dark mode, and enhanced animations.
