//
//  CropView.swift
//  CropView
//
//  Created by Michele Mola on 23/10/2019.
//  Copyright © 2019 Michele Mola. All rights reserved.
//
import UIKit
import PinLayout

enum LongPressSide {
	case left
	case top
	case right
	case bottom
	case topLeft
	case bottomLeft
	case topRight
	case bottomRight
}

class CropView: UIView {
	
	let scrollableImageView = ScrollableAndZoomingImageView()
	let cropRectView = CropRectView()
	
	let topMaskView = UIView()
	let leftMaskView = UIView()
	let rightMaskView = UIView()
	let bottomMaskView = UIView()
	
	var side: LongPressSide?
	var leftMargin: CGFloat = 0
	var rightMargin: CGFloat = 0
	var topMargin: CGFloat = 0
	var bottomMargin: CGFloat = 0
	let minRectSize: CGFloat = 100
	
	var image: UIImage? {
		didSet {
			self.update()
		}
	}
	
	// Interactions
	var didEndCropping: ((CGRect) -> ())?
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		self.setup()
		self.style()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setup() {
		let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.didLongPress(_:)))
		longPressRecognizer.minimumPressDuration = 0.1
		
		self.addGestureRecognizer(longPressRecognizer)
		
		self.setupInteractions()
		
		self.addSubview(self.scrollableImageView)
		self.addSubview(self.cropRectView)
		
		self.addSubview(self.topMaskView)
		self.addSubview(self.leftMaskView)
		self.addSubview(self.rightMaskView)
		self.addSubview(self.bottomMaskView)
	}
	
	private func setupInteractions() {
		self.scrollableImageView.didZoom = { [unowned self] in
			self.updateMargins()
		}
		
		self.scrollableImageView.willBeginZooming = { [unowned self] in
			self.changeAlphaMasks(to: 0)
		}
		
		self.scrollableImageView.didEndZooming = { [unowned self] in
			self.changeAlphaMasks(to: 0.4)
		}
	}
	
	func style() {
		self.backgroundColor = .white
		
		self.topMaskView.backgroundColor = .black
		self.topMaskView.isUserInteractionEnabled = false

		self.leftMaskView.backgroundColor = .black
		self.leftMaskView.isUserInteractionEnabled = false
		
		self.rightMaskView.backgroundColor = .black
		self.rightMaskView.isUserInteractionEnabled = false
		
		self.bottomMaskView.backgroundColor = .black
		self.bottomMaskView.isUserInteractionEnabled = false
		
		self.changeAlphaMasks(to: 0.4)
	}
	
	private func update() {
		self.scrollableImageView.image = self.image
				
		self.updateMargins()
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()

		self.scrollableImageView.pin
			.all(pin.safeArea)
				
		self.cropRectView.pin
			.left(to: self.scrollableImageView.edge.left)
			.marginLeft(self.leftMargin)
			.top(to: self.scrollableImageView.edge.top)
			.marginTop(self.topMargin)
			.right(to: self.scrollableImageView.edge.right)
			.marginRight(self.rightMargin)
			.bottom(to: self.scrollableImageView.edge.bottom)
			.marginBottom(self.bottomMargin)
		
		let scrollViewContentInset = self.scrollableImageView.scrollView.adjustedContentInset
		
		self.topMaskView.pin
			.left(to: self.scrollableImageView.edge.left)
			.marginLeft(scrollViewContentInset.left)
			.right(to: self.scrollableImageView.edge.right)
			.marginRight(scrollViewContentInset.right)
			.top(to: self.scrollableImageView.edge.top)
			.marginTop(floor(scrollViewContentInset.top))
			.above(of: self.cropRectView)
		
		self.leftMaskView.pin
			.left(to: self.scrollableImageView.edge.left)
			.marginLeft(scrollViewContentInset.left)
			.below(of: self.topMaskView)
			.bottom(to: self.scrollableImageView.edge.bottom)
			.marginBottom(floor(scrollViewContentInset.bottom))
			.before(of: self.cropRectView)

		self.rightMaskView.pin
			.below(of: self.topMaskView)
			.right(to: self.scrollableImageView.edge.right)
			.marginRight(floor(scrollViewContentInset.right))
			.after(of: self.cropRectView)
			.bottom(to: self.scrollableImageView.edge.bottom)
			.marginBottom(floor(scrollViewContentInset.bottom))

		self.bottomMaskView.pin
			.horizontallyBetween(self.leftMaskView, and: self.rightMaskView)
			.below(of: self.cropRectView)
			.bottom(to: self.scrollableImageView.edge.bottom)
			.marginBottom(floor(scrollViewContentInset.bottom))
	}
	
	private func updateMargins() {
		let scrollViewContentInset = self.scrollableImageView.scrollView.contentInset
		
		self.leftMargin = self.leftMargin <= scrollViewContentInset.left
											? scrollViewContentInset.left
											: self.leftMargin
		self.topMargin = self.topMargin <= scrollViewContentInset.top
										 ? scrollViewContentInset.top
										 : self.topMargin
		self.rightMargin = self.rightMargin <= scrollViewContentInset.right
											 ? scrollViewContentInset.right
											 : self.rightMargin
		self.bottomMargin = self.bottomMargin <= scrollViewContentInset.bottom
												? scrollViewContentInset.bottom
												: self.bottomMargin
		
		if self.topMargin + self.bottomMargin > self.scrollableImageView.bounds.height - self.minRectSize {
			let offset = self.minRectSize - self.cropRectView.bounds.height
			
			if self.topMargin == scrollViewContentInset.top {
				self.bottomMargin -= offset
			}
			
			if self.bottomMargin == scrollViewContentInset.bottom {
				self.topMargin -= offset
			}
		}
		
		self.setNeedsLayout()
		self.layoutIfNeeded()
	}
	
	private func changeAlphaMasks(to value: CGFloat) {
		UIView.animate(withDuration: 0.3) { [unowned self] in
			self.leftMaskView.alpha = value
			self.topMaskView.alpha = value
			self.rightMaskView.alpha = value
			self.bottomMaskView.alpha = value
		}
	}
	
	@objc func didLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
		let location = gestureRecognizer.location(in: self.cropRectView)
		
		let cropRectViewWidth = self.cropRectView.bounds.width
		let cropRectViewHeight = self.cropRectView.bounds.height
		
		switch gestureRecognizer.state {
		case .began:
			guard let side = self.getPressSide(from: location) else { break }
			self.side = side
			self.changeCropBorderWidth()
			self.cropRectView.isHiddenGrid = false
		case .changed:
			guard let side = self.side else { break }
			
			switch side {
			case .left:
				let offset = self.leftMargin + location.x
				self.leftMargin = self.computeMargin(.left, withOffset: offset)
				
			case .right:
				let offset = self.rightMargin + (cropRectViewWidth - location.x)
				self.rightMargin = self.computeMargin(.right, withOffset: offset)
				
			case .top:
				let offset = self.topMargin + location.y
				self.topMargin = self.computeMargin(.top, withOffset: offset)

			case .bottom:
				let offset = self.bottomMargin + (cropRectViewHeight - location.y)
				self.bottomMargin = self.computeMargin(.bottom, withOffset: offset)
				
			case .topLeft:
				let topOffset = self.topMargin + location.y
				let leftOffset = self.leftMargin + location.x

				self.topMargin = self.computeMargin(.top, withOffset: topOffset)
				self.leftMargin = self.computeMargin(.left, withOffset: leftOffset)
				
			case .bottomLeft:
				let bottomOffset = self.bottomMargin + (cropRectViewHeight - location.y)
				let leftOffset = self.leftMargin + location.x
				
				self.bottomMargin = self.computeMargin(.bottom, withOffset: bottomOffset)
				self.leftMargin = self.computeMargin(.left, withOffset: leftOffset)
				
			case .topRight:
				let topOffset = self.topMargin + location.y
				let rightOffset = self.rightMargin + (cropRectViewWidth - location.x)
				
				self.topMargin = self.computeMargin(.top, withOffset: topOffset)
				self.rightMargin = self.computeMargin(.right, withOffset: rightOffset)
				
			case .bottomRight:
				let bottomOffset = self.bottomMargin + (cropRectViewHeight - location.y)
				let rightOffset = self.rightMargin + (cropRectViewWidth - location.x)

				self.bottomMargin = self.computeMargin(.bottom, withOffset: bottomOffset)
				self.rightMargin = self.computeMargin(.right, withOffset: rightOffset)
			}
			
			self.setNeedsLayout()
			self.layoutIfNeeded()
		case .ended:
			guard self.side != nil else { break }
			self.changeCropBorderWidth()
			self.cropRectView.isHiddenGrid = true
			self.side = nil
			
			let zoomScale = self.scrollableImageView.scrollView.zoomScale
			let convertedFrame = convert(self.cropRectView.frame, to: self.scrollableImageView.scrollView)
			let zoomedFrame = CGRect(x: convertedFrame.origin.x / zoomScale, y: convertedFrame.origin.y / zoomScale, width: convertedFrame.size.width / zoomScale, height: convertedFrame.size.height / zoomScale)
			
			self.didEndCropping?(zoomedFrame)
		default:
			break
		}
	}
	
	private func getPressSide(from point: CGPoint) -> LongPressSide? {
		let cropRectViewWidth = self.cropRectView.bounds.width
		let cropRectViewHeight = self.cropRectView.bounds.height
		
		let recognizableAreaSize: CGFloat = 16
		
		switch point {
		case let point where -recognizableAreaSize...recognizableAreaSize ~= point.x && recognizableAreaSize...cropRectViewHeight-recognizableAreaSize ~= point.y:
			return .left
		case let point where cropRectViewWidth-recognizableAreaSize...cropRectViewWidth+recognizableAreaSize ~= point.x && recognizableAreaSize...cropRectViewHeight-recognizableAreaSize ~= point.y:
			return .right
		case let point where -recognizableAreaSize...recognizableAreaSize ~= point.y && recognizableAreaSize...cropRectViewWidth-recognizableAreaSize ~= point.x:
			return .top
		case let point where cropRectViewHeight-recognizableAreaSize...cropRectViewHeight+recognizableAreaSize ~= point.y && recognizableAreaSize...cropRectViewWidth-recognizableAreaSize ~= point.x:
			return .bottom
		case let point where -recognizableAreaSize...recognizableAreaSize ~= point.x && -recognizableAreaSize...recognizableAreaSize ~= point.y:
			return .topLeft
		case let point where -recognizableAreaSize...recognizableAreaSize ~= point.x && cropRectViewHeight-recognizableAreaSize...cropRectViewHeight+recognizableAreaSize ~= point.y:
			return .bottomLeft
		case let point where cropRectViewWidth-recognizableAreaSize...cropRectViewWidth+recognizableAreaSize ~= point.x && cropRectViewHeight-recognizableAreaSize...cropRectViewHeight+recognizableAreaSize ~= point.y:
			return .bottomRight
		case let point where cropRectViewWidth-recognizableAreaSize...cropRectViewWidth+recognizableAreaSize ~= point.x && -recognizableAreaSize...recognizableAreaSize ~= point.y:
			return .topRight
		default: break
		}
		
		return nil
	}
	
	private func changeCropBorderWidth() {
		self.cropRectView.layer.borderWidth = self.cropRectView.layer.borderWidth == 2 ? 3 : 2
	}
	
	private func computeMargin(_ side: LongPressSide, withOffset offset: CGFloat) -> CGFloat {
		let scrollableImageViewWidth = self.scrollableImageView.bounds.width
		let scrollableImageViewHeight = self.scrollableImageView.bounds.height
		
		let scrollViewContentInset = self.scrollableImageView.scrollView.contentInset

		var margin: CGFloat = 0
		
		switch side {
		case .left:
			margin = self.repairMargin(fromOffset: offset, margin: self.rightMargin, scrollableImageViewSize: scrollableImageViewWidth, andInset: scrollViewContentInset.left)
		case .right:
			margin = self.repairMargin(fromOffset: offset, margin: self.leftMargin, scrollableImageViewSize: scrollableImageViewWidth, andInset: scrollViewContentInset.right)
		case .top:
			margin = self.repairMargin(fromOffset: offset, margin: self.bottomMargin, scrollableImageViewSize: scrollableImageViewHeight, andInset: scrollViewContentInset.top)
		case .bottom:
			margin = self.repairMargin(fromOffset: offset, margin: self.topMargin, scrollableImageViewSize: scrollableImageViewHeight, andInset: scrollViewContentInset.bottom)
		default:
			break
		}

		return margin
	}
	
	private func repairMargin(fromOffset offset: CGFloat, margin: CGFloat, scrollableImageViewSize: CGFloat, andInset inset: CGFloat) -> CGFloat {
		var repairedMargin: CGFloat = 0
		let margins = offset + margin
		
		if offset < inset {
			repairedMargin = inset
		} else if scrollableImageViewSize - margins <= self.minRectSize {
			repairedMargin = scrollableImageViewSize - margin - self.minRectSize
		} else {
			repairedMargin = offset
		}
		
		return repairedMargin
	}
	
	
}

