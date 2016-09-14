# Font

[![CI Status](https://img.shields.io/travis/adamyanalunas/Font.svg?style=flat)](https://travis-ci.org/adamyanalunas/Font)
[![Version](https://img.shields.io/cocoapods/v/Font.svg?style=flat)](http://cocoapods.org/pods/Font)
[![License](https://img.shields.io/cocoapods/l/Font.svg?style=flat)](http://cocoapods.org/pods/Font)
[![Platform](https://img.shields.io/cocoapods/p/Font.svg?style=flat)](http://cocoapods.org/pods/Font)

## Demo

You can either run `pod try Font` from your command line or clone the repo and run `pod install` from the Example directory followed by loading up the Example workspace.

## Swift 3.0

Font is now Swift 3.0 ready. If you need Swift 2.3 support, the `swift2.3` branch is available but it will not receive updates except for maybe the occasional bugfix.

Changes required by the 3.0 change:

* Initial argument names are now required on many methods
* `FontWeight` and `FontStyle` values are lowercased
* `.bold` was added to `FontWeight`

## Example

First step, you need to make a Font extension to properly describe how your custom font responds to various weights and styles. Here's an example for Adobe’s [Source Sans Pro](https://adobe-fonts.github.io/source-sans-pro/). Note that the function `SourceSansPro`’s **name and signature are entirely fabricated**. You could name it `StandardFont` or `BodyFont`. You could withhold options for italic or size. Entirely up to you and the flexibility of your font.

```swift
extension Font {
    private static func sourceSansProWeight(weight:FontWeight) -> String {
        switch weight {
        case .Ultralight:
            return "ExtraLight"

        case .Thin:
            fallthrough
        case .Light:
            return "Light"

        case .Regular:
            fallthrough
        case .Medium:
            return "Regular"

        case .Semibold:
            return "Semibold"

        case .Heavy:
            return "Bold"

        case .Black:
            return "Black"
        }
    }

    private static func name(weight:FontWeight, style:FontStyle) -> String {
        let base = "SourceSansPro"
        let weightNumber = sourceSansProWeight(weight)

        let weightAndStyle:String
        switch style {
        case _ where style == .Italic && (weight == .Regular || weight == .Medium):
            weightAndStyle = "It"
        case .Italic:
            weightAndStyle = "\(weightNumber)It"
        default:
            weightAndStyle = weightNumber
        }

        return "\(base)-\(weightAndStyle)"
    }

    static func SourceSansPro(size:CGFloat = 16, weight:FontWeight = .Medium, style:FontStyle = .None) -> Font {
        let fontName = name(weight, style:style)
        return Font(fontName: fontName, size: size)
    }
}
```

Great! Now use your custom font. Create an instance of your Font and generate a `UIFont` to assign to some `UILabel`. Then, configure your view controller (or what have you) to pay attention to when the user changes the Dynamic Type size. You don't have to worry about what size the user has picked, Font will take care of that.

```swift
class ViewController: UIViewController {

    @IBOutlet weak var exampleLabel:UILabel!
    var headlineFont:Font!

    override func viewDidLoad() {
        super.viewDidLoad()

        headlineFont = Font.SourceSansPro(36, style: .Italic)
        exampleLabel.font = headlineFont.generate()
    }

    extension ViewController: DynamicTypeListener {
        // Subscribe to UIContentSizeCategoryDidChangeNotification notifications
        override func viewWillAppear(animated: Bool) {
            super.viewWillAppear(animated)

            listenForDynamicTypeChanges()
        }

        // Unsubscribe from UIContentSizeCategoryDidChangeNotification notifications
        override func viewWillDisappear(animated: Bool) {
            super.viewWillDisappear(animated)

            ignoreDynamicTypeChanges()
        }

        // Do something when UIContentSizeCategoryDidChangeNotification notifications come in
        func respondToDynamicTypeChanges(notification:NSNotification) {
            exampleLabel.font = headlineFont.generate()
        }
    }
```

## Custom Font Sizing

Want more control over exactly what point size is chosen for the Dynamic Type size the user has set? Define your own parser and pass it to the `generate()` function when creating a `UIFont` instance.

```swift
…
    func restrainedSizes(sizeClass:String) -> CGFloat {
        let adjustedSize:CGFloat

        switch sizeClass {
        case UIContentSizeCategoryExtraSmall:
            fallthrough
        case UIContentSizeCategorySmall:
            fallthrough
        case UIContentSizeCategoryMedium:
            fallthrough
        case UIContentSizeCategoryLarge:
            adjustedSize = size //16
        case UIContentSizeCategoryExtraLarge:
            adjustedSize = floor(size * 1.15) //18
        case UIContentSizeCategoryExtraExtraLarge:
            adjustedSize = floor(size * 1.25) //20
        case UIContentSizeCategoryExtraExtraExtraLarge:
            adjustedSize = floor(size * 1.4) //22
        case UIContentSizeCategoryAccessibilityMedium:
            fallthrough
        case UIContentSizeCategoryAccessibilityLarge:
            fallthrough
        case UIContentSizeCategoryAccessibilityExtraLarge:
            fallthrough
        case UIContentSizeCategoryAccessibilityExtraExtraLarge:
            fallthrough
        case UIContentSizeCategoryAccessibilityExtraExtraExtraLarge:
            adjustedSize = floor(size * 1.65) //26
        default:
            adjustedSize = 16
        }

        return adjustedSize
    }

    func updateFonts() {
        someLabel.font = yourFont.generate(resizer:restrainedSizes)
    }
…
```

## Requirements

* Swift
* Licensed font

## Installation

Font is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "Font"
```

## No fonts are being generated?

* Did you [add your fonts to your `Info.plist`](http://codewithchris.com/common-mistakes-with-adding-custom-fonts-to-your-ios-app/)?
* Did you create [an extension for `Font`](https://github.com/adamyanalunas/Font/blob/master/Example/Font/Typefaces/Source%20Sans%20Pro/SourceSansPro.swift) with your custom font rules?
* Does your font support the weights you want? Unless it’s a full family you might not have ultralight or black weights.
* Does your extension correctly name the font? Use Font Book (`/Applications/Font Book.app`) to check the PostScript name of the font.

## Contribution

* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet.
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it.
* Fork the project and submit a pull request from a feature or bugfix branch.
* Please include tests. This is important so we don't break your changes unintentionally in a future version.
* Please don't modify the podspec, version, or changelog. If you do change these files, please isolate a separate commit so we can cherry-pick around it.

## Author

Adam Yanalunas, adam@yanalunas.com

## License

Font is available under the MIT license. See the LICENSE file for more info.
