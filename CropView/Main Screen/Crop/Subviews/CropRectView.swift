//
//  CropRectView.swift
//  CropView
//
//  Created by Michele Mola on 24/10/2019.
//  Copyright © 2019 Michele Mola. All rights reserved.
//

import UIKit

class CropRectView: UIView {
	
	var isHiddenGrid: Bool = true {
		didSet {
			self.update()
		}
	}

	override init(frame: CGRect) {
		super.init(frame: frame)
		
		self.setup()
		self.style()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setup() {
		self.isUserInteractionEnabled = false
	}
	
	func style() {
		self.layer.borderColor = UIColor.yellow.cgColor
		self.layer.borderWidth = 2
		self.backgroundColor = .clear
			
		self.drawCorners()
	}
	
	func update() {
		if self.isHiddenGrid {
			self.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
		} else {
			self.drawGrid()
		}
	}
		
	override func layoutSubviews() {
		super.layoutSubviews()
		self.layer.sublayers?.removeAll()

		self.drawCorners()
		self.drawGrid()
	}
	
	private func drawCorners() {
			
		// Top left corner
		let topLeftCornerShapeLayer = CAShapeLayer()
		topLeftCornerShapeLayer.bounds = CGRect(x: 0, y: 0, width: 20, height: 20)
		topLeftCornerShapeLayer.lineWidth = 2
		topLeftCornerShapeLayer.fillColor = UIColor.clear.cgColor
		topLeftCornerShapeLayer.strokeColor = UIColor.yellow.cgColor
		topLeftCornerShapeLayer.anchorPoint = .zero
		
		let topLeftCornerShapePath = UIBezierPath()
		topLeftCornerShapePath.move(to: CGPoint(x: 2, y: 22))
		topLeftCornerShapePath.addLine(to: CGPoint(x: 2, y: 2))
		topLeftCornerShapePath.addLine(to: CGPoint(x: 22, y: 2))
		
		topLeftCornerShapeLayer.path = topLeftCornerShapePath.cgPath
		
		// Top right corner
		let topRightCornerShapeLayer = CAShapeLayer()
		topRightCornerShapeLayer.bounds = CGRect(x: 0, y: 0, width: 20, height: 20)
		topRightCornerShapeLayer.lineWidth = 2
		topRightCornerShapeLayer.fillColor = UIColor.clear.cgColor
		topRightCornerShapeLayer.strokeColor = UIColor.yellow.cgColor
		topRightCornerShapeLayer.anchorPoint = .zero
		
		let topRightCornerShapePath = UIBezierPath()
		topRightCornerShapePath.move(to: CGPoint(x: self.bounds.width - 22, y: 2))
		topRightCornerShapePath.addLine(to: CGPoint(x: self.bounds.width - 2, y: 2))
		topRightCornerShapePath.addLine(to: CGPoint(x: self.bounds.width - 2, y: 22))
		
		topRightCornerShapeLayer.path = topRightCornerShapePath.cgPath
		
		// Bottom left corner
		let bottomLeftCornerShapeLayer = CAShapeLayer()
		bottomLeftCornerShapeLayer.bounds = CGRect(x: 0, y: 0, width: 20, height: 20)
		bottomLeftCornerShapeLayer.lineWidth = 2
		bottomLeftCornerShapeLayer.fillColor = UIColor.clear.cgColor
		bottomLeftCornerShapeLayer.strokeColor = UIColor.yellow.cgColor
		bottomLeftCornerShapeLayer.anchorPoint = .zero
		
		let bottomLeftCornerShapePath = UIBezierPath()
		bottomLeftCornerShapePath.move(to: CGPoint(x: 2, y: self.bounds.height - 22))
		bottomLeftCornerShapePath.addLine(to: CGPoint(x: 2, y: self.bounds.height - 2))
		bottomLeftCornerShapePath.addLine(to: CGPoint(x: 22, y: self.bounds.height - 2))
		
		bottomLeftCornerShapeLayer.path = bottomLeftCornerShapePath.cgPath
		
		// Bottom right corner
		let bottomRightCornerShapeLayer = CAShapeLayer()
		bottomRightCornerShapeLayer.bounds = CGRect(x: 0, y: 0, width: 20, height: 20)
		bottomRightCornerShapeLayer.lineWidth = 2
		bottomRightCornerShapeLayer.fillColor = UIColor.clear.cgColor
		bottomRightCornerShapeLayer.strokeColor = UIColor.yellow.cgColor
		bottomRightCornerShapeLayer.anchorPoint = .zero
		
		let bottomRightCornerShapePath = UIBezierPath()
		bottomRightCornerShapePath.move(to: CGPoint(x: self.bounds.width - 2, y: self.bounds.height - 22))
		bottomRightCornerShapePath.addLine(to: CGPoint(x: self.bounds.width - 2, y: self.bounds.height - 2))
		bottomRightCornerShapePath.addLine(to: CGPoint(x: self.bounds.width - 22, y: self.bounds.height - 2))
		
		bottomRightCornerShapeLayer.path = bottomRightCornerShapePath.cgPath
		
		
		self.layer.addSublayer(topLeftCornerShapeLayer)
		self.layer.addSublayer(topRightCornerShapeLayer)
		self.layer.addSublayer(bottomLeftCornerShapeLayer)
		self.layer.addSublayer(bottomRightCornerShapeLayer)
	}
	
	private func drawGrid() {

		guard !isHiddenGrid else { return }
		
		// First vertical line
		let firstVerticalLineShapeLayer = CAShapeLayer()
		firstVerticalLineShapeLayer.bounds = CGRect(x: 0, y: 0, width: 20, height: 20)
		firstVerticalLineShapeLayer.lineWidth = 1
		firstVerticalLineShapeLayer.fillColor = UIColor.clear.cgColor
		firstVerticalLineShapeLayer.strokeColor = UIColor.yellow.cgColor
		firstVerticalLineShapeLayer.anchorPoint = .zero
		firstVerticalLineShapeLayer.opacity = 0.6
		
		let firstVerticalLineShapePath = UIBezierPath()
		firstVerticalLineShapePath.move(to: CGPoint(x: self.bounds.width / 3, y: 0))
		firstVerticalLineShapePath.addLine(to: CGPoint(x: self.bounds.width / 3, y: self.bounds.height))
		
		firstVerticalLineShapeLayer.path = firstVerticalLineShapePath.cgPath
		
		// Second vertical line
		let secondVerticalLineShapeLayer = CAShapeLayer()
		secondVerticalLineShapeLayer.bounds = CGRect(x: 0, y: 0, width: 20, height: 20)
		secondVerticalLineShapeLayer.lineWidth = 1
		secondVerticalLineShapeLayer.fillColor = UIColor.clear.cgColor
		secondVerticalLineShapeLayer.strokeColor = UIColor.yellow.cgColor
		secondVerticalLineShapeLayer.anchorPoint = .zero
		secondVerticalLineShapeLayer.opacity = 0.6
		
		let secondVerticalLineShapePath = UIBezierPath()
		secondVerticalLineShapePath.move(to: CGPoint(x: self.bounds.width / (3/2), y: 0))
		secondVerticalLineShapePath.addLine(to: CGPoint(x: self.bounds.width / (3/2), y: self.bounds.height))
		
		secondVerticalLineShapeLayer.path = secondVerticalLineShapePath.cgPath
		
		// First horizontal line
		let firstHorizontalLineShapeLayer = CAShapeLayer()
		firstHorizontalLineShapeLayer.bounds = CGRect(x: 0, y: 0, width: 20, height: 20)
		firstHorizontalLineShapeLayer.lineWidth = 1
		firstHorizontalLineShapeLayer.fillColor = UIColor.clear.cgColor
		firstHorizontalLineShapeLayer.strokeColor = UIColor.yellow.cgColor
		firstHorizontalLineShapeLayer.anchorPoint = .zero
		firstHorizontalLineShapeLayer.opacity = 0.6
		
		let firstHorizontalLineShapePath = UIBezierPath()
		firstHorizontalLineShapePath.move(to: CGPoint(x: 0, y: self.bounds.height / 3))
		firstHorizontalLineShapePath.addLine(to: CGPoint(x: self.bounds.width, y: self.bounds.height / 3))
		
		firstHorizontalLineShapeLayer.path = firstHorizontalLineShapePath.cgPath
		
		// Second horizontal line
		let secondHorizontalLineShapeLayer = CAShapeLayer()
		secondHorizontalLineShapeLayer.bounds = CGRect(x: 0, y: 0, width: 20, height: 20)
		secondHorizontalLineShapeLayer.lineWidth = 1
		secondHorizontalLineShapeLayer.fillColor = UIColor.clear.cgColor
		secondHorizontalLineShapeLayer.strokeColor = UIColor.yellow.cgColor
		secondHorizontalLineShapeLayer.anchorPoint = .zero
		secondHorizontalLineShapeLayer.opacity = 0.6
		
		let secondHorizontalLineShapePath = UIBezierPath()
		secondHorizontalLineShapePath.move(to: CGPoint(x: 0, y: self.bounds.height / (3/2)))
		secondHorizontalLineShapePath.addLine(to: CGPoint(x: self.bounds.width, y: self.bounds.height / (3/2)))
		
		secondHorizontalLineShapeLayer.path = secondHorizontalLineShapePath.cgPath
		
		self.layer.addSublayer(firstVerticalLineShapeLayer)
		self.layer.addSublayer(secondVerticalLineShapeLayer)
		self.layer.addSublayer(firstHorizontalLineShapeLayer)
		self.layer.addSublayer(secondHorizontalLineShapeLayer)
	}
	
	
}


