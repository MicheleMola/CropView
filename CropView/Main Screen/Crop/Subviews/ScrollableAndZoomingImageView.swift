//
//  ScrollableAndZoomingImageView.swift
//  CropView
//
//  Created by Michele Mola on 24/10/2019.
//  Copyright © 2019 Michele Mola. All rights reserved.
//

import UIKit
import PinLayout

typealias Interaction = () -> ()

class ScrollableAndZoomingImageView: UIView {
	
	var imageView = UIImageView()
	var scrollView = UIScrollView()
	
	var image: UIImage? {
		didSet {
			self.update()
		}
	}
	
	// Interactions
	var didEndZooming: Interaction?
	var willBeginZooming: Interaction?
	var didZoom: Interaction?
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		self.setup()
		self.style()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setup() {
		self.scrollView.delegate = self
		
		self.imageView.contentMode = .scaleAspectFit
		
		self.scrollView.showsVerticalScrollIndicator = false
		self.scrollView.showsHorizontalScrollIndicator = false
		self.scrollView.bouncesZoom = false

		self.addSubview(self.scrollView)
		self.scrollView.addSubview(self.imageView)
	}
	
	func style() {
		self.backgroundColor = .white
	
		self.scrollView.backgroundColor = .white
	}
	
	func update() {
		self.imageView.image = image
		self.imageView.frame.size = self.imageView.image!.size
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		self.scrollView.pin
			.all()
		
		self.setZoomParameters(self.scrollView.bounds.size)
		self.centerImage()
	}
	
	private func setZoomParameters(_ scrollViewSize: CGSize) {
		let imageSize = self.imageView.bounds.size
		let widthScale = scrollViewSize.width / imageSize.width
		let heightScale = scrollViewSize.height / imageSize.height
		let minScale = min(widthScale, heightScale)
		
		self.scrollView.minimumZoomScale = minScale
		self.scrollView.maximumZoomScale = 3.0
		self.scrollView.zoomScale = minScale
	}
	
	private func centerImage() {
		let scrollViewSize = self.scrollView.bounds.size
		let imageSize = self.imageView.frame.size
				
		let horizontalSpace = imageSize.width < scrollViewSize.width ? (scrollViewSize.width - imageSize.width) / 2 : 0
		
		let verticalSpace = imageSize.height < scrollViewSize.height ? (scrollViewSize.height - imageSize.height) / 2 : 0
				
		self.scrollView.contentInset = UIEdgeInsets(top: verticalSpace, left: horizontalSpace, bottom: verticalSpace, right: horizontalSpace)
	}
	
}

extension ScrollableAndZoomingImageView: UIScrollViewDelegate {
	func viewForZooming(in scrollView: UIScrollView) -> UIView? {
		return self.imageView
	}
	
	func scrollViewDidZoom(_ scrollView: UIScrollView) {
		self.centerImage()
		self.didZoom?()
	}
	
	func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
		self.willBeginZooming?()
	}
	
	func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
		self.didEndZooming?()
	}
	
}

