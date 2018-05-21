# GDGauge

Full Customizable, Beautiful gauge view.

Completely written with ShapeLayers and CoreGraphic to get a most clean and smooth, everything!

[ Now with more options to customize! ]

![1](https://user-images.githubusercontent.com/9967486/40322974-4ccd8c1e-5d49-11e8-9adc-8c8569335484.png)


![2](https://user-images.githubusercontent.com/9967486/40007543-5107d6dc-57b2-11e8-834c-a1062ded1a7b.png)


![gauge](https://user-images.githubusercontent.com/9967486/39946456-7a3569c4-5583-11e8-8e54-8e10ed4774ee.gif)


# Requirements
- Xcode 9+
- Swift 4
- iOS 8+


# Installation
Install manually
------
Drag `GDGauge.swift` to your project and use!

## Using Cocoapods
```
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '9.0'
use_frameworks!

target '<Your Target Name>' do
    pod 'GDGauge'
end
```
`pod update` then `pod install`

# How to use

```swift 
    override func viewDidLoad() {
        super.viewDidLoad()

        // Create and instatiate the view and set parameters
        speed = GDGaugeView(frame: view.bounds)
        
        // Set main gauge view color
        speed.baseColor = UIColor.cyan
        
        // Show circle border
        speed.showBorder = true
        
        // Show full circle border if .showBorder is set to true
        speed.fullBorder = false
        
        // Set starting degree based on zero degree on bottom center of circle space
        speed.startDegree = 45.0
        
        // Set ending degree based on zero degree on bottom center of circle space
        speed.endDegree = 270.0

        // Minimum value
        speed.min = 0.0
        
        // Maximum value
        speed.max = 16
        
        // Determine each step value
        speed.stepValue = 4.0
        
        // Color of handle
        speed.handleColor = UIColor.cyan
        
        // Color of seprators
        speed.sepratorColor = UIColor.black
        
        // Color of texts
        speed.textColor = UIColor.black
        
        // Center indicator text
        speed.unitText = "mb/s"
        
        // Center indicator font
        speed.unitTextFont = UIFont.systemFont(ofSize: 10)
        
        // Indicators text
        speed.textFont = UIFont.systemFont(ofSize: 20)
        view.addSubview(speed)

        /// After configuring the component, call setupView() method to create the gauge view
        speed.setupView() 

    }
```

## Check sample project for details and lots of more info!



## Licence

GDGauge is available under the MIT license. See the [LICENSE.txt](https://github.com/saeid/GDGauge/blob/master/LICENSE) file for more info.
