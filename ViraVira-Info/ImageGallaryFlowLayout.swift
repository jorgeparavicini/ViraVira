//
//  ImageGalleryFlowLayout.swift
//  ViraVira-Info
//
//  Created by Jorge Paravicini on 3/02/17.
//  Copyright © 2017 Jorge Paravicini. All rights reserved.
//

import UIKit

class ImageGallaryFlowLayout: UICollectionViewFlowLayout {

	
	override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
		print("Wurking")
		var offsetAdjustment = CGFloat(MAXFLOAT)
		let spacing: CGFloat = 8
		let horizontalOffset: CGFloat = proposedContentOffset.x + spacing
		
		let targetRect = CGRect(x: proposedContentOffset.x, y: 0, width: self.collectionView!.bounds.width, height: self.collectionView!.bounds.height)
		
		let attributesArray = super.layoutAttributesForElements(in: targetRect)
		
		for layoutAttribute in attributesArray! {
			let itemOffset = layoutAttribute.frame.origin.x
			if abs(itemOffset - horizontalOffset) < abs(offsetAdjustment) {
				offsetAdjustment = itemOffset - horizontalOffset
			}
		}
		
		return CGPoint(x: proposedContentOffset.x + offsetAdjustment, y: proposedContentOffset.y)
	}
	
	
}
