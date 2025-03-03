//
//  ActionLabel.swift
//  ActionLabel
//
//  Created by Hanson on 3/3/25.
//
import UIKit

typealias TouchAction = (String) -> Void

// Define a custom attribute key for tap actions
extension NSAttributedString.Key {
	static let tapAction = NSAttributedString.Key("action")
}

class ActionLabel: UILabel {
	
	// MARK: - Property Overrides
	
	// Override attributedText to update text storage when set
	override open var attributedText: NSAttributedString? {
		didSet { updateTextStorage() }
	}
	
	// Override font to update text attributes when set
	override var font: UIFont? {
		didSet { updateAttributes(.font, value: font) }
	}
	
	// Override textColor to update text attributes when set
	override var textColor: UIColor? {
		didSet { updateAttributes(.foregroundColor, value: textColor) }
	}
	
	// MARK: - Text Rendering Setup
	
	// Lazy properties for text rendering
	internal lazy var textStorage = NSTextStorage() // Stores the attributed text
	fileprivate lazy var layoutManager = NSLayoutManager() // Manages text layout
	fileprivate lazy var textContainer = NSTextContainer() // Defines text container for layout
	fileprivate var heightCorrection: CGFloat = 0 // Corrects vertical alignment
	
	// Override drawText to customize text rendering
	open override func drawText(in rect: CGRect) {
		let range = NSRange(location: 0, length: textStorage.length)
		
		textContainer.size = rect.size
		let newOrigin = textOrigin(inRect: rect)
		
		// Draw background and glyphs for the text
		layoutManager.drawBackground(forGlyphRange: range, at: newOrigin)
		layoutManager.drawGlyphs(forGlyphRange: range, at: newOrigin)
	}
	
	// Updates text attributes when font or color changes
	func updateAttributes(_ name: NSAttributedString.Key, value: Any?) {
		guard let newValue = value,
			  let attributedText = attributedText else { return }
		let newAttText: NSMutableAttributedString? = attributedText.mutableCopy() as? NSMutableAttributedString
		
		if let newAttText = newAttText {
			let range = NSMakeRange(0, newAttText.string.count)
			newAttText.addAttribute(name, value: newValue, range: range)
			self.attributedText = newAttText
		}
	}
	
	// MARK: - Initialization
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupLabel()
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		setupLabel()
	}
	
	// Sets up the label for text rendering and interaction
	fileprivate func setupLabel() {
		numberOfLines = 0
		textStorage.addLayoutManager(layoutManager)
		layoutManager.addTextContainer(textContainer)
		textContainer.lineFragmentPadding = 0
		textContainer.lineBreakMode = lineBreakMode
		textContainer.maximumNumberOfLines = numberOfLines
		isUserInteractionEnabled = true // Enable touch interactions
	}
	
	// Updates the text storage with the current attributed text
	fileprivate func updateTextStorage() {
		// Clean up previous active elements
		guard let attributedText = attributedText, attributedText.length > 0 else {
			textStorage.setAttributedString(NSAttributedString())
			setNeedsDisplay()
			return
		}
		
		textStorage.setAttributedString(attributedText)
		setNeedsDisplay()
	}
	
	// Calculates the origin point for text rendering
	fileprivate func textOrigin(inRect rect: CGRect) -> CGPoint {
		let usedRect = layoutManager.usedRect(for: textContainer)
		heightCorrection = (rect.height - usedRect.height) / 2
		let glyphOriginY = heightCorrection > 0 ? rect.origin.y + heightCorrection : rect.origin.y
		return CGPoint(x: rect.origin.x, y: glyphOriginY)
	}
	
	// MARK: - Auto Layout
	
	// Override intrinsicContentSize for proper auto layout sizing
	open override var intrinsicContentSize: CGSize {
		guard let text = text, !text.isEmpty else {
			return .zero
		}

		textContainer.size = CGSize(width: self.preferredMaxLayoutWidth, height: CGFloat.greatestFiniteMagnitude)
		let size = layoutManager.usedRect(for: textContainer)
		return CGSize(width: ceil(size.width), height: ceil(size.height))
	}
	
	// MARK: - Touch Handling
	
	// Handle touch events to detect taps on specific text ranges
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesEnded(touches, with: event)
		guard let location = touches.first?.location(in: self) else { return }
		onTouch(at: location)
	}
	
	// Process touch location to trigger tap actions
	fileprivate func onTouch(at location: CGPoint) {
		guard textStorage.length > 0 else {
			return
		}
		
		var correctLocation = location
		correctLocation.y -= heightCorrection
		let boundingRect = layoutManager.boundingRect(forGlyphRange: NSRange(location: 0, length: textStorage.length), in: textContainer)
		guard boundingRect.contains(correctLocation) else {
			return
		}
		
		// Find the character index at the touch location
		let charIndex = layoutManager.glyphIndex(for: correctLocation, in: textContainer)
		
		var effectiveRange = NSRange()
		// Check if a tap action is defined for the character index
		if let tapAction = attributedText?.attribute(.tapAction, at: charIndex, effectiveRange: &effectiveRange) {
			if let action = tapAction  as? TouchAction {
				let text = attributedText?.attributedSubstring(from: effectiveRange).string ?? ""
				action(text) // Execute the tap action
			} else if let action = tapAction  as? () -> Void {
				action()
			}
		}
	}
}
