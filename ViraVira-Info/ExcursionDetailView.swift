//
//  ExcursionDetailView.swift
//  ViraVira-Info
//
//  Created by Jorge Paravicini on 15/08/16.
//  Copyright © 2016 Jorge Paravicini. All rights reserved.
//

import UIKit
import KVConstraintExtensionsMaster
import MapKit
import DeviceKit

class ExcursionDetailView: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, ImageGallaryCollectionViewDelegate {
    //MARK: - Properties
	var excursion: ExcursionDataModel! = nil {
		didSet {
			if self.isViewLoaded {
				//updateTableHeight()
			}
		}
	}
	
    @IBOutlet weak var excursionTitle: UINavigationItem!
    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var collectionView: UICollectionView!
	@IBOutlet weak var separator: UIView!
	
	@IBOutlet weak var mapButton: UIButton!
	
	@IBOutlet weak var contentView: UIView!
	@IBOutlet weak var excursionImageDescriptionView: ExcursionImageDescription!
	//MARK: Collection View Layout
	var flowLayout = UICollectionViewFlowLayout()
	var imageGallaryFlowLayout = ImageGallaryFlowLayout()
	
	fileprivate var isStatusBarHidden: Bool = false
	
	fileprivate var detailViewDismisserButton: UIBarButtonItem?
	
	var imageGallary: UIView?
	
	var mapProperties: JPMapProperty?
	
	//table view
	@IBOutlet weak var tableView: DynamicUITableView!
	@IBOutlet weak var tableHeight: NSLayoutConstraint!
    
	let tableCellHeightRatio: CGFloat = 0.1
    let tableIconHeightRatio: CGFloat = 0.07
    
    let descriptionTextInset: CGFloat = 8
    
    var tableCells = [ExcursionDetailTableViewCell]()
    
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.automaticallyAdjustsScrollViewInsets = false
		
		excursionTitle.title = excursion.title
        descriptionText.text = excursion.m_description
		updateTextViewSize()
		
		//Creating the delegate links between the collection view and this class, so we can modify various aspects of the collectionview
        collectionView.delegate = self
        collectionView.dataSource = self
		
		
		//Collection View layout initialization
		flowLayout.scrollDirection = UICollectionViewScrollDirection.horizontal
		imageGallaryFlowLayout.scrollDirection = UICollectionViewScrollDirection.horizontal
		
		detailViewDismisserButton = navigationController?.navigationBar.topItem?.leftBarButtonItem
		
		collectionView.isPagingEnabled = true
		collectionView.bounces = false
		collectionView.isScrollEnabled = true
		
		NotificationCenter.default.addObserver(self, selector: #selector(ExcursionDetailView.rotate), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
		
		let nib = UINib(nibName: "ImageGallaryCollectionViewCell", bundle: nil)
		collectionView.register(nib, forCellWithReuseIdentifier: "Cell")
		
		if excursion.doesGPXExist {
			let parser = JPMapParser(xmlURL: excursion.gpxFileURL!, location: excursion.location!, span: excursion.span!, maxSpan: excursion.maxSpan!)
			parser.parse() { (mapProperties) in
				self.mapProperties = mapProperties
			}
		}
		
		mapButton.layer.cornerRadius = 5
		mapButton.layer.borderColor = UIColor.black.cgColor
		
		if !excursion.doesGPXExist {
			mapButton.setTitle("Map: Coming soon", for: .normal)
		}
		
		tableView.delegate = self
		tableView.dataSource = self
		tableView.isScrollEnabled = false
		
		
		setColors()
		selectText()
		
		/*tableView.rowHeight = UITableViewAutomaticDimension
		tableView.estimatedRowHeight = 40*/
		//adjustTableViewHeight()
		//updateTableHeight()
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		updateHeight()
	}
	
	//Updates all the views in the detail view to the according correct ones declared in UIColor
	func setColors() {
		self.view.backgroundColor = UIColor.secondary
		
		collectionView.backgroundColor = UIColor.clear
		contentView.backgroundColor = UIColor.clear
		
		mapButton.backgroundColor = UIColor.primary
		mapButton.titleLabel?.textColor = UIColor.secondary
		
		separator.backgroundColor = UIColor.primary
		excursionImageDescriptionView.textColor = UIColor.primary
		
		//tableView
		tableView.backgroundColor = UIColor.clear
		tableView.separatorColor = UIColor.primary
	}
	
	override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
		
		let fixedWidth = descriptionText.frame.size.width
		let newSize = descriptionText.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
		var newFrame = descriptionText.frame
		newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
		descriptionText.frame = newFrame
	}
	
//	MARK: - Collection view setup
	
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		if let images = excursion.images {
            return images.count
        }
        return 1
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ImageGallaryCollectionViewCell
		
		if let images = excursion.images {
			let imageURL = images[indexPath.item].0
			DispatchQueue.global().async {
				cell.imageView.sd_setImage(with: imageURL, placeholderImage: #imageLiteral(resourceName: "PlaceHolder"))
			}
        } else {
            cell.imageView.image = #imageLiteral(resourceName: "ImageNotFound")
        }
		
		cell.imageView.contentMode = .scaleAspectFit
        return cell
    }
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let size = CGSize(width: collectionView.frame.width - 8, height: collectionView.frame.height - 16)
		
		return size
	}
	
	func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
		selectText()
	}
	
	func selectText() {
		guard self.collectionView.indexPathsForVisibleItems.count > 0 else {
			/*excursionImageDescriptionView.isHidden = true
			self.view.setNeedsLayout()
			self.view.layoutIfNeeded()*/
			return
		}
		//excursionImageDescriptionView.isHidden = false
		//self.view.setNeedsLayout()
		//self.view.layoutIfNeeded()
		
		let indexes = self.collectionView.indexPathsForVisibleItems
		var index = 0
		index = indexes[0].item
		excursionImageDescriptionView.text = excursion.images![index].1
	}
	
	func selectedImageIndex() -> IndexPath? {
		guard collectionView.visibleCells.count > 0 else {return nil}
		
		let selectedCell = collectionView.visibleCells[0]
		let indexPath = collectionView.indexPath(for: selectedCell)
		return indexPath
	}
	
//	MARK: - Listeners
	
//	Handles any taps recognized by the gesturerexognizer on the Image Gallery
	@IBAction func handleTap(_ sender: UITapGestureRecognizer) {
//		Show/Hide the description for the image gallery
		//excursionImageDescriptionView.animate()
		showImageInspector()
	}
	
//	Listens to any device rotation
	func rotate() {
		if imageGallary != nil {
			imageGallary!.superview?.setNeedsLayout()
			imageGallary!.superview?.layoutIfNeeded()
			reloadImageInspectorData()
			imageInspectorSelectMostVisibleCell()
		}
		self.collectionView.reloadData()
		selectText()
		
		//updateTableHeight()
       // tableView.reloadData()
       // adjustTableViewHeight()
	}
	
//	MARK: - View translations
	
	func updateTextViewSize() {
		let fixedWidth = descriptionText.frame.size.width
		let newSize = descriptionText.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
		var newFrame = descriptionText.frame
		newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
		descriptionText.frame = newFrame
	}
	
//	MARK: - Image Inspector
	
	func showImageInspector() {
		//toggleNavigationDisplay()
		
		navigationBarImageInspectorDismisser()
		
		imageGallary = createImageGallery()
		(imageGallary!.subviews[0] as! UICollectionView).reloadData()
	}
	
	func createImageGallery() -> UIView {
		
//		The color scheme used by this gallery
		let color = UIColor.secondary
//		Frame for the parenting view
		let screenFrame = UIScreen.main.bounds
		
//		Create the superview with the screen frame
		let superView = UIView(frame: collectionView.frame)
		superView.translatesAutoresizingMaskIntoConstraints = false
		superView.backgroundColor = color
		superView.alpha = 0
		
//		Adding the parenting view on top to the current view and applying it's constraints
		view.addSubview(superView)
		//let keyView = UIApplication.shared.keyWindow
		//keyView?.addSubview(superView)
		superView.applyConstraintFitToSuperview()
		
//		The insets that the collection view will have. This is used to the limitation of the flow layout
		let collectionViewInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//		Here we create the frame for the collection view
		let insetedFrame = galleryViewRect(parentViewRect: screenFrame, collectionViewInsets: collectionViewInsets)
		
//		Creates the collection view that will contain all the images, adding it to the parenting view and applying the constraints
		let imageInspector = createImageInspector(with: insetedFrame)
		superView.addSubview(imageInspector)
		imageInspector.applyTopPinConstraint(toSuperview: collectionViewInsets.top)
		imageInspector.applyBottomPinConstraint(toSuperview: collectionViewInsets.bottom)
		imageInspector.applyLeadingPinConstraint(toSuperview: collectionViewInsets.left)
		imageInspector.applyTrailingPinConstraint(toSuperview: collectionViewInsets.right)
		
//		Animates the entrance of the view to fit the new frame
		
		UIView.animate(withDuration: 0.3, animations: {() -> Void in
			superView.frame = screenFrame
			superView.alpha = 1
			
		}, completion: {(Bool) -> Void in
			self.imageGallary?.setNeedsLayout()
			imageInspector.isUserInteractionEnabled = true
		})
		
		return superView
	}
	
	func galleryViewRect(parentViewRect rect: CGRect, collectionViewInsets: UIEdgeInsets) -> CGRect {
		var newRect = rect
		
		newRect.origin.x += collectionViewInsets.left
		newRect.size.width -= (collectionViewInsets.left + collectionViewInsets.right)
		newRect.origin.y += collectionViewInsets.top
		newRect.size.width -= (collectionViewInsets.top + collectionViewInsets.bottom)
		
		return newRect
	}
	
	func createImageInspector(with rect: CGRect) -> UICollectionView {
		
		let collectionView = ImageGallaryCollectionView(frame: rect, collectionViewLayout: flowLayout)
		
		collectionView.backgroundColor = UIColor.viraviraBrownColor
		collectionView.register(UINib(nibName: "ImageGallaryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
		collectionView.delegate = collectionView
		collectionView.dataSource = collectionView
		
		collectionView.imageGallaryDelegate = self
		
		if excursion.images != nil {
			var images = [URL]()
			for element in excursion.images! {
				images.append(element.0)
			}
			
			collectionView.imageURLS = images
		}
		
		let index = selectedImageIndex()
		
		collectionView.selectItem(at: index != nil ? index : IndexPath(), animated: false, scrollPosition: UICollectionViewScrollPosition.centeredVertically)
		
		collectionView.isUserInteractionEnabled = false
		collectionView.translatesAutoresizingMaskIntoConstraints = false
		
		collectionView.alwaysBounceHorizontal = true
		collectionView.alwaysBounceVertical = false
		collectionView.isPagingEnabled = true
		
		collectionView.isDirectionalLockEnabled = true
		
		collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)
		//		The color scheme used by this gallery
		let color = UIColor.viraviraDarkBrownColor
		collectionView.backgroundColor = color
		
		//collectionView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ExcursionDetailView.dismissImageInspector)))
		return collectionView
	}
	
	func reloadImageInspectorData() {
		guard
			self.imageGallary != nil,
			let collectionView = imageGallary?.subviews[0] as? UICollectionView
			else {return}
		collectionView.reloadData()
		collectionView.setNeedsLayout()
		collectionView.layoutIfNeeded()
	}
	
	func imageInspectorSelectMostVisibleCell() {
		guard
			self.imageGallary != nil,
			imageGallary?.subviews[0] as? UICollectionView != nil
			else {return}
		
		let paths = (imageGallary?.subviews[0] as! UICollectionView).indexPathsForVisibleItems
		if paths.count > 0 {
			(imageGallary!.subviews[0] as! UICollectionView).scrollToItem(at: paths[0], at: .centeredHorizontally, animated: false)
		}
	}
	
	func navigationBarImageInspectorDismisser() {
		let button = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(ExcursionDetailView.dismissImageInspector))
		button.tintColor = UIColor.secondary
		navigationController?.navigationBar.topItem?.leftBarButtonItem = button
	}
	
	func navigationBarDetailViewDismisser() {
		navigationController?.navigationBar.topItem?.leftBarButtonItem = detailViewDismisserButton
	/*	let button = UIBarButtonItem(image: #imageLiteral(resourceName: "back"), style: .plain, target: self, action: #selector(ExcursionDetailView.unwindToTableView))
		button.tintColor = UIColor.viraviraGoldColor
		navigationController?.navigationBar.topItem?.leftBarButtonItem = button*/
	}
	
	func unwindToTableView() {
		self.shouldPerformSegue(withIdentifier: "unwind", sender: self)
	}
	
	func dismissImageInspector() {
		guard imageGallary != nil else {return}
		
		//toggleNavigationDisplay()
		
		UIView.animate(withDuration: 0.3, animations: {() -> Void in
			//self.imageGallary!.frame = self.collectionView.frame
			//self.imageGallary!.backgroundColor = self.imageGallary!.backgroundColor?.withAlphaComponent(0)
			self.imageGallary?.alpha = 0
		}, completion: {(Bool) -> Void in
			self.imageGallary!.removeFromSuperview()
			
		})
		
		navigationBarDetailViewDismisser()
	}
	
//	MARK: - Image Gallary delegate implementations
	func set(alpha: CGFloat) {
		self.imageGallary?.alpha = alpha
	}
	
	func dismissImageGallary() {
		dismissImageInspector()
	}
	
//	MARK: Navigation bar
	
	func toggleNavigationDisplay() {
		toggleNavigationBar()
		toggleStatusBar()
	}
	
	func toggleNavigationBar() {
		guard let navController = self.navigationController else {return}
		navController.setNavigationBarHidden(!navController.isNavigationBarHidden, animated: true)
	}
	
	func toggleStatusBar() {
		isStatusBarHidden = !isStatusBarHidden
		UIView.animate(withDuration: 0.2, animations: {() -> Void in
			self.setNeedsStatusBarAppearanceUpdate()
		})
	}
	
	override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
		return UIStatusBarAnimation.slide
	}
	
	override var prefersStatusBarHidden: Bool {
		return isStatusBarHidden
	}
	
	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}
	
//	MARK: - Map 
	
	@IBAction func mapButton(_ sender: Any) {
		guard excursion.doesGPXExist else {return}
		let mapController = ExcursionMapViewController(nibName: "ExcursionMapViewController", bundle: nil)
		self.navigationController?.pushViewController(mapController, animated: true)
		navigationController?.navigationBar.tintColor = UIColor.secondary
		
		if mapProperties != nil {
			mapController.mapProperties = mapProperties
		} else {
			mapController.parser = JPMapParser(xmlURL: excursion.gpxFileURL!, location: excursion.location!, span: excursion.span!, maxSpan: excursion.maxSpan!)
		}
	}
	
}

extension ExcursionDetailView: UITableViewDelegate, UITableViewDataSource {
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return excursion.tableContent != nil ? excursion.tableContent!.count : 0
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ExcursionDetailTableViewCell
		let currentTableData = excursion.tableContent![indexPath.row]
		
		cell.backgroundColor = UIColor.clear
		
		cell.icon.image = currentTableData.icon.withRenderingMode(.alwaysTemplate)
		cell.icon.tintColor = UIColor.primary
		
      //  cell.height.constant = UIScreen.main.bounds.height * tableIconHeightRatio
       // self.view.setNeedsLayout()
		
		cell.descriptionText.text = currentTableData.text
		cell.descriptionText.textColor = UIColor.primary
		//cell.descriptionText.adjustsFontSizeToFitWidth = true
		//cell.descriptionText.minimumScaleFactor = 0.2
		cell.descriptionText.font = cell.descriptionText.font.withSize(fontSize())
       // cell.descriptionText.setMaxFontSize(minSize: 7, maxSize: 21)
        
        if !tableCells.contains(cell) {
            tableCells.insert(cell, at: indexPath.row)
        }
		
        if (self.tableView(tableView, numberOfRowsInSection: 0) - 1) == indexPath.row {
           // updateTableHeight()
		}
		
		return cell
	}
	
	func fontSize() -> CGFloat {
		
		//let bounds = UIScreen.main.bounds
		//let width = bounds.width < bounds.height ? bounds.width : bounds.height
		
		//print(width)
		
		return 16
	}
	
	/*func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return UITableViewAutomaticDimension
	}*/
	
	func updateHeight() {
		let height = tableViewHeight()
		tableHeight.constant = height
		self.view.updateConstraints()
	}
	
	func tableViewHeight() -> CGFloat {
		var height: CGFloat = 0
		for i in 0..<tableView(tableView, numberOfRowsInSection: 0) {
			height += tableView(tableView, heightForRowAt: IndexPath(row: i, section: 0))
		}
		return height
	}
    
 /*   func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height * tableCellHeightRatio
    }*/
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let minHeight = UIScreen.main.bounds.height * tableCellHeightRatio
        
        guard tableCells.count > indexPath.row else {return minHeight}
        let cell = tableCells[indexPath.row]
    
        //let cell = self.tableView(tableView, cellForRowAt: indexPath) as! ExcursionDetailTableViewCell
		
		let topBottomIndent: CGFloat = 16
		var contentHeight = self.labelHeight(cell.descriptionText)
		//if !UIDevice.current.orientation.isLandscape {
			contentHeight += 2 * descriptionTextInset
		//}
		//  print(contentHeight)
		
        let textViewHeight = contentHeight + topBottomIndent
        
        return textViewHeight > minHeight ? textViewHeight : minHeight
	}
	
	func labelHeight(_ label: UILabel) -> CGFloat {
		label.numberOfLines = 0
		let insets: CGFloat = 40
		let cellwidth: CGFloat = UIScreen.main.bounds.size.height * tableCellHeightRatio
		let fixedWidth = UIScreen.main.bounds.size.width - cellwidth - insets
		
		let sizeThatFits = label.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat(MAXFLOAT)))
		return sizeThatFits.height
	}
	
  /* func textViewHeight(_ textView: UITextView) -> CGFloat {
	/* CGFloat fixedWidth = textView.frame.size.width;
	CGSize newSize = [textView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
	CGRect newFrame = textView.frame;
	newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
	textView.frame = newFrame;
	*/
	let insets: CGFloat = 40
	
	
	let fixedWidth = textView.frame.size.width
	let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat(MAXFLOAT)))
	return newSize.height
    }*/
	
	/*func labelHeight(_ label: UILabel) -> CGFloat {
		label.numberOfLines = 0
		let sizeThatFits = label.sizeThatFits(CGSize(width: label.frame.width, height: CGFloat(MAXFLOAT)))
		return sizeThatFits.height
		
	}*/
	
	/*func updateTableHeight() {
        
		let rowCount = tableView(tableView, numberOfRowsInSection: 0)
        var height: CGFloat = 0
        for row in 0..<rowCount {
            height += tableView(tableView, heightForRowAt: IndexPath(row: row, section: 0))
        }
        
		tableViewHeight.constant = height
		self.view.setNeedsLayout()
	}*/
}
