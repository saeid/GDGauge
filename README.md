# GDGauge

Customizable, Beautiful Gauge View.   
Using ShapeLayers and CoreGraphic for rendering the whole view to get great and smooth experience!

![1](https://user-images.githubusercontent.com/9967486/40322974-4ccd8c1e-5d49-11e8-9adc-8c8569335484.png)

# Requirements
- Xcode 10+
- Swift 4.2
- iOS 9+


# Installation

## Cocoapods
```
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '9.0'
use_frameworks!

target '<Your Target Name>' do
    pod 'GDGauge'
end
```
    pod update
    pod install

# Usage
```swift
import GDGauge
```

Create an instance of GDGaugeView
```swift
var gaugeView: GDGaugeView = GDGaugeView(frame: view.bounds)
```

Set its properties
```swift 
gaugeView.baseColor = UIColor.cyan
gaugeView.startDegree = 45.0        
gaugeView.endDegree = 270.0
gaugeView.min = 0.0
gaugeView.max = 16
gaugeView.unitText = "mb/s"

...

// Full properties list can be found on sample project
```

Build customized view
```swift
gaugeView.setupView() 
```



## Licence

GDGauge is available under the MIT license. See the [LICENSE.txt](https://github.com/saeid/GDGauge/blob/master/LICENSE) file for more info.
