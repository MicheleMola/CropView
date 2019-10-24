//
//  ViewController.swift
//  CropView
//
//  Created by Michele Mola on 23/10/2019.
//  Copyright © 2019 Michele Mola. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	
	let cropView = CropView()

	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.setup()
		self.setupInteractions()
	}
	
	override func loadView() {
		self.view = self.cropView
	}
	
	private func setup() {
		self.cropView.image = UIImage(named: "Mercoledì.jpg")
	}
	
	private func setupInteractions() {
		self.cropView.didEndCropping = { [weak self] cropRect in
			guard let self = self else { return }
			
			// Generate the cropped image from cropRect (CGRect)
			if let image = self.cropView.image?.cgImage?.cropping(to: cropRect) {
				let croppedImage = UIImage(cgImage: image)
				print(croppedImage.size)
			}
		}
	}
}

