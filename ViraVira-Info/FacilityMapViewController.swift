//
//  FacilityMapViewController.swift
//  ViraVira-Info
//
//  Created by Jorge Paravicini on 22/04/17.
//  Copyright © 2017 Jorge Paravicini. All rights reserved.
//

import UIKit

class FacilityMapViewController: UIViewController {
	
	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var scrollView: UIScrollView!
	@IBOutlet weak var imageViewBottomConstraint: NSLayoutConstraint!
	@IBOutlet weak var imageViewLeadingConstraint: NSLayoutConstraint!
	@IBOutlet weak var imageViewTopConstraint: NSLayoutConstraint!
	@IBOutlet weak var imageViewTrailingConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()

		scrollView.delegate = self
		
        self.view.backgroundColor = UIColor.secondary
    }
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		
		updateMinZoomScale(for: view.bounds.size)
	}
	
	private func updateMinZoomScale(for size: CGSize) {
		let widthScale = size.width / imageView.bounds.width
		let heightScale = size.height / imageView.bounds.height
		let minScale = min(widthScale, heightScale)
		
		scrollView.minimumZoomScale = minScale
		scrollView.zoomScale = minScale
	}
	

}

extension FacilityMapViewController: UIScrollViewDelegate {
	func viewForZooming(in scrollView: UIScrollView) -> UIView? {
		return imageView
	}
	
	func scrollViewDidZoom(_ scrollView: UIScrollView) {
		updateConstraints(for: view.bounds.size)
	}
	
	private func updateConstraints(for size: CGSize) {
		let yOffset = max(0, (size.height - imageView.frame.height) / 2)
		imageViewTopConstraint.constant = yOffset
		imageViewBottomConstraint.constant = yOffset
		
		view.layoutIfNeeded()
	}
}
