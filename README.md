# GDGauge - Customizable Gauge View

Easy to use, highly customizable gauge view.   


![1](https://user-images.githubusercontent.com/9967486/40322974-4ccd8c1e-5d49-11e8-9adc-8c8569335484.png)

# Requirements
- Xcode 11+
- Swift 5
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

Setup, customize and build the view
```swift 
        gaugeView
            .setupGuage(startDegree: CGFloat,
                        endDegree: CGFloat,
                        sectionGap: CGFloat,
                        minValue: CGFloat,
                        maxValue: CGFloat)
            .setupContainer(width: CGFloat,
                            color: UIColor,
                            handleColor: UIColor,
                            shouldShowContainerBorder: Bool,
                            shouldShowFullCircle: Bool,
                            indicatorsColor: UIColor,
                            indicatorsValuesColor: UIColor,
                            indicatorsFont: UIFont)
            .setupUnitTitle(title: String,
                            font: UIFont)
            .buildGauge()
```

### Other methods
To update the handle value
```swift
gaugeView.updateValueTo(CGFloat)
```

To update colors when a limit is reached
```swift
gaugeView.updateColors(containerColor: UIColor,
                        indicatorsColor: UIColor)
```

To reset to initial colors
```swift
gaugeView.resetColors()
```

## Licence
GDGauge is available under the MIT license. See the [LICENSE.txt](https://github.com/saeid/GDGauge/blob/master/LICENSE) file for more info.
