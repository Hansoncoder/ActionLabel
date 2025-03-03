# ActionLabel

## Overview
ActionLabel is a custom UILabel subclass designed to support tappable text elements using attributed strings. It leverages `NSLayoutManager`, `NSTextContainer`, and `NSTextStorage` to efficiently render text and detect user interactions on specific text ranges.

## Features
- Supports attributed text with custom actions on specific ranges.
- Handles dynamic font and text color updates.
- Custom text rendering with background drawing.
- Detects touch interactions and triggers associated actions.

## Implementation Details
- Uses `NSAttributedString.Key.tapAction` as a custom attribute key to store tap actions.
- Overrides `drawText(in:)` for custom text rendering.
- Implements `intrinsicContentSize` for accurate auto layout sizing.
- Processes touch events to determine tapped character indices and execute actions.

## Usage
To use `ActionLabel`, assign an attributed string with the `.tapAction` attribute set to a closure that should be executed when the text is tapped:

```swift
let label = ActionLabel()
let text = NSMutableAttributedString(string: "Tap here to perform an action")
text.addAttribute(.tapAction, value: { print("Text tapped!") }, range: NSRange(location: 0, length: 3))
label.attributedText = text
```

## Requirements
- iOS 13.0+
- Swift 5+

## License
This project is available under the MIT license.

