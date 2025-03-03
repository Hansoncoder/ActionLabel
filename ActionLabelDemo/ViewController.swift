//
//  ViewController.swift
//  ActionLabelDemo
//
//  Created by Hanson on 3/3/25.
//

import UIKit

// ViewModel to provide attributed text with interactive actions
struct TestViewModel {
	
	// Attributed string where part of the text is tappable and prints the tapped text
	var needText: NSAttributedString {
		let text = "click labe test" // The complete text
		let attText = NSMutableAttributedString(string: text)
		let range = NSMakeRange(11, 4) // The range for "test"
		
		// Define a tap action that prints the tapped text
		let action: TouchAction = { text in print("\(text)") }
		
		// Apply attributes: tap action, red text color, and underline
		attText.addAttributes([
			.tapAction: action,
			.foregroundColor: UIColor.red,
			.underlineStyle: NSUnderlineStyle.single.rawValue
		], range: range)
		
		return attText
	}
	
	// Attributed string where part of the text is tappable but triggers a fixed message
	var voidText: NSAttributedString {
		let text = "click labe test" // The complete text
		let attText = NSMutableAttributedString(string: text)
		let range = NSMakeRange(11, 4) // The range for "test"
		
		// Define a tap action that prints a fixed message
		attText.addAttributes([
			.tapAction: { print("click text") },
			.foregroundColor: UIColor.red,
			.underlineStyle: NSUnderlineStyle.single.rawValue
		], range: range)
		
		return attText
	}
}

// ViewController to display the interactive label
class ViewController: UIViewController {
	
	// Instantiate the ViewModel
	lazy var vm = TestViewModel()
	lazy var actionLabel = ActionLabel()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Create and configure ActionLabel
		view.addSubview(actionLabel)
		actionLabel.frame = CGRect(x: 100, y: 200, width: 200, height: 50) // Set frame position and size
		
		// Set the attributed text with tap action
		actionLabel.attributedText = vm.needText
		actionLabel.font = UIFont.systemFont(ofSize: 18) // Set font size
	}
	
	func testExample() {
		let attributedText = NSMutableAttributedString(string: "click labe test")
		let range = NSMakeRange(11, 4) // The range for "test"
		
		// Define a tap action that prints a fixed message
		attributedText.addAttributes([
			.tapAction: { print("click text") }
		], range: range)
		actionLabel.attributedText = attributedText
	}
}
