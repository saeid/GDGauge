# GDGauge - Customizable Gauge View

![1](https://user-images.githubusercontent.com/9967486/40322974-4ccd8c1e-5d49-11e8-9adc-8c8569335484.png)

# Requirements
- Xcode 11+
- Swift 5
- iOS 9+


# Installation

## Swift Package Manager

```swift
.package(url: "https://github.com/saeid/GDGauge.git", from: "2.0.0")
```

## Cocoapods (Not updated - Latest version "1.2.1")
```ruby
pod 'GDGauge'
```

# Usage

### Import GDGauge
```swift
import GDGauge
```

### Create an instance of GDGaugeView
```swift
var gaugeView = GDGaugeView(frame: view.bounds)
```

### Setup, customize and build the view
```swift 
        gaugeView
            .setupGuage(
                startDegree: CGFloat,
                endDegree: CGFloat,
                sectionGap: CGFloat,
                minValue: CGFloat,
                maxValue: CGFloat
            )
            .setupContainer(
                width: CGFloat,
                color: UIColor,
                handleColor: UIColor,
                options: GaugeOptions,
                indicatorsColor: UIColor,
                indicatorsValuesColor: UIColor,
                indicatorsFont: UIFont
            )
            .setupUnitTitle(
                title: String,
                font: UIFont
            )
            .buildGauge()
```

### To update the handle value
```swift
gaugeView.updateValueTo(CGFloat)
```

### To update colors when a limit is reached
```swift
gaugeView.updateColors(
    containerColor: UIColor,
    indicatorsColor: UIColor
)
```

### To reset to initial colors
```swift
gaugeView.resetColors()
```

## Licence
GDGauge is available under the MIT license. See the [LICENSE.txt](https://github.com/saeid/GDGauge/blob/master/LICENSE) file for more info.
