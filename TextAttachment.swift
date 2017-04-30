//
//  TextAttachment.swift
//  ViraVira-Info
//
//  Created by Jorge Paravicini on 27/01/17.
//  Copyright © 2017 Jorge Paravicini. All rights reserved.
//

import UIKit

class TextAttachment: NSTextAttachment {

	override func attachmentBounds(for textContainer: NSTextContainer?, proposedLineFragment lineFrag: CGRect, glyphPosition position: CGPoint, characterIndex charIndex: Int) -> CGRect {

		if image == nil {
			return lineFrag
		}
		
		let height: CGFloat = lineFrag.size.height
		let imageSize = image!.size
		let scalingFactor: CGFloat = height / imageSize.height
		
		let rect = CGRect(x: 0, y: 0, width: imageSize.width * scalingFactor, height: imageSize.height * scalingFactor)
		return rect
	}
}
