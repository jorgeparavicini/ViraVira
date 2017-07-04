//
//  imageGallaryCollectionView.swift
//  ViraVira-Info
//
//  Created by Jorge Paravicini on 2/02/17.
//  Copyright © 2017 Jorge Paravicini. All rights reserved.
//

import UIKit
import SDWebImage

class ImageGallaryCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
	
	var imageURLS: [URL]?
	var reuseIdentifier = "Cell"
	
	var imageGallaryDelegate: ImageGallaryCollectionViewDelegate?

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		guard let cells = imageURLS else {return 0}
		return cells.count
	}
	
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
		guard let imageCell = cell as? ImageGallaryCollectionViewCell else {return cell}
		
		if imageURLS?[indexPath.item] != nil {
			imageCell.imageView.sd_setImage(with: imageURLS![indexPath.item], placeholderImage: #imageLiteral(resourceName: "PlaceHolder"))
		} else {
			imageCell.imageView.image = #imageLiteral(resourceName: "ImageNotFound")
		}
		
		imageCell.collectionView = self
		
		imageCell.imageView.contentMode = .scaleAspectFit
		
		return imageCell
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let size = CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
		return size
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
		return 0
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return 0
	}
	
	func selectedCell() -> ImageGallaryCollectionViewCell? {
		let visibleCellsIndexes = self.indexPathsForVisibleItems
		guard visibleCellsIndexes.count > 0 else {return nil}
		
		return self.cellForItem(at: visibleCellsIndexes[0]) as? ImageGallaryCollectionViewCell
	}
}
