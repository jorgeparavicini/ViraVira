//
//  ImageGallaryCollectionViewCell.swift
//  ViraVira-Info
//
//  Created by Jorge Paravicini on 1/02/17.
//  Copyright © 2017 Jorge Paravicini. All rights reserved.
//

import UIKit

protocol ImageGallaryCollectionViewDelegate {
	func set(alpha: CGFloat) -> Void
	func dismissImageGallary() -> Void
}

class ImageGallaryCollectionViewCell: UICollectionViewCell, UIScrollViewDelegate {

	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var scrollView: UIScrollView!
	
	var collectionView: ImageGallaryCollectionView?
	
	//	This value is used to determine how far the user will have to scroll until the collection view will be dismissed
	let offsetNeededToRemove: CGFloat = 80
	//	This value is used to determine at what point from the center the view will be completely opaque
	let fullOpacityPosition: CGFloat = 200
	
	fileprivate var willClose = false
	
	override func awakeFromNib() {
		super.awakeFromNib()
		scrollView.minimumZoomScale = 1.0
		scrollView.maximumZoomScale = 5.0
		scrollView.delegate = self
		scrollView.alwaysBounceVertical = true
		scrollView.alwaysBounceHorizontal = false
	}
	
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		guard !willClose && scrollView.zoomScale == 1 else {return}
		var offset = abs(scrollView.contentOffset.y)
		offset -= abs(zoomOffset().y)
		/*print("offset 1: \(offset)")
		print("imageOffset: \(abs(imageOffset().y))")
//		offset = abs(offset)
		offset -= abs(imageOffset().y)
		if offset < 0 {
			offset = 0
		}
		print("offset 2: \(offset)")
//		if offset < 0 {
//			offset = 0
//		}
//		print(offset)*/
		
		
		
		//let alpha = 1 - 1 / fullOpacityPosition * offset
		let alpha = 1 - pow(offset, 2) / pow(fullOpacityPosition, 2)
		collectionView?.imageGallaryDelegate?.set(alpha: alpha)
	}
	
	func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
		guard scrollView.zoomScale == 1 else {return}
		var offset = abs(scrollView.contentOffset.y)
		offset -= zoomOffset().y
		if offset >= offsetNeededToRemove {
			willClose = true
			collectionView?.imageGallaryDelegate?.dismissImageGallary()
		}
	}
	func viewForZooming(in scrollView: UIScrollView) -> UIView? {
		return imageView
	}
	
	func zoomOffset() -> CGPoint {
		let width = scrollView.frame.width/2 * (scrollView.zoomScale - 1)
		let height = scrollView.frame.height/2 * (scrollView.zoomScale - 1)
		return CGPoint(x: width, y: height)
	}
	
	func imageOffset() -> CGPoint {
		let width = imageSize().width / 2 * scrollView.zoomScale
		let height = imageSize().height / 2 * scrollView.zoomScale
		return CGPoint(x: width, y: height)
	}

	
	func imageSize() -> CGSize {
		let width = imageView.image!.size.width * scrollView.zoomScale / UIScreen.main.scale
		let height = imageView.image!.size.height * scrollView.zoomScale / UIScreen.main.scale
		return CGSize(width: width, height: height)
	}
}

