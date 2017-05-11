//
//  UsefullInformationViewController.swift
//  ViraVira-Info
//
//  Created by Jorge Paravicini on 21/04/17.
//  Copyright © 2017 Jorge Paravicini. All rights reserved.
//

import UIKit
import KVConstraintExtensionsMaster

class UsefullInformationViewController: UIViewController {

    @IBOutlet weak var tableView: ExpandableTableView!
	
	var labelFontSize: CGFloat {
		get {
			switch (self.view.traitCollection.horizontalSizeClass, self.view.traitCollection.verticalSizeClass) {
			case (.regular, .regular):
				return 24
			case (.compact, .compact):
				return 17
				
			default:
				return 17
			}
		}
	}
    
    override func viewDidLoad() {
        super.viewDidLoad()
		tableView.backgroundColor = UIColor.secondary
		tableView.separatorStyle = .none
		tableView.showsVerticalScrollIndicator = false
		tableView.showsHorizontalScrollIndicator = false
		tableView.sections = populate()
    }
	
	func populate() -> [ExpandableTableViewSection] {
		var sections = [ExpandableTableViewSection]()
		sections.append(ExpandableTableViewSection(name: "Hotel", content: [hotelView()]))
		sections.append(ExpandableTableViewSection(name: "Location", content: [locationView()]))
		sections.append(ExpandableTableViewSection(name: "Climate", content: [climateView()]))
		sections.append(ExpandableTableViewSection(name: "Recommended Clothing", content: [recommendedClothingView()]))
		sections.append(ExpandableTableViewSection(name: "Electricity", content: [electricityView()]))
		sections.append(ExpandableTableViewSection(name: "Language", content: [languageView()]))
		sections.append(ExpandableTableViewSection(name: "Internet", content: [internetView()]))
		sections.append(ExpandableTableViewSection(name: "Currency", content: [currencyView()]))
		sections.append(ExpandableTableViewSection(name: "Room Amenities", content: [roomAmenitiesView()]))
		sections.append(ExpandableTableViewSection(name: "All Inclusive Package", content: [allInclusivePackageView()]))
		sections.append(ExpandableTableViewSection(name: "Excursions", content: [excursionView()]))
		sections.append(ExpandableTableViewSection(name: "Restaurant", content: [restaurantView()]))
		sections.append(ExpandableTableViewSection(name: "Tipping", content: [tippingView()]))
		sections.append(ExpandableTableViewSection(name: "Families", content: [familiesView()]))
		sections.append(ExpandableTableViewSection(name: "Medical Facilities", content: [medicalFacilitiesView()]))
		
		return sections
	}
	
	func hotelView() -> UIView {
		return lableView(with: "Our Hacienda Hotel Vira Vira is set in a beautiful and unique location close to Pucón, Chile. It features a 23ha native park along the shores of the Liucura River and offers an oasis of peace and recreation. The Vira Vira Hotel brings a new concept of vacation to life – we call it “The Elegance of Adventure” which means that a large range of exclusive activities and excursions are part of your “all inclusive” stay with the Hotel. We look forward to welcoming you at our Hacienda Hotel.")
	}
	
	func locationView() -> UIView {
		return lableView(with: "Pucón – also called the “Entrance of the Cordillera” by local Mapuche – is the ideal starting point for your adventures. This picturesque city turns in a melting point for numerous tourists and offers an unrivaled number of excursions and activities surrounded by breathless views and landscapes. The village is situated along the shores of the Villarrica Lake at the foot of the active Volcano Villarrica and its rather stable weather (especially in the summer) make it the secret destination of the Chilean experienced traveler. \n Pucón – situated roughly 780 Km south of Santiago or 100 Km southeast of Temuco – can easily be reached by plane to Temuco or by Bus or car. We recommend the Premium bus service from Turbus that offers an overnight passage with 180° seats – a great way to start your vacation. The city is at a height of 220m above sea and has about 25.000 inhabitants.")
	}
	
	func climateView() -> UIView {
		return lableView(with: "Pucón’s climate tends to be Mediterranean, with temperate, short summers and cold humid winters. The summer period (October to March) is usually characterized by moderate to warm weather with relatively plenty of sunshine and moderate rains. It is the ideal travel period for horseback riding, hiking, and all kind of water activities and for ascents to the Volcano. The winter in Pucón is usually quite cold and offers unusual and interesting winter activities such as skiing on the Volcano, snowshoeing in Natural Parks, horseback riding or pure relaxation in one of the many natural hot springs or to enjoy a great Yoga class or other in-house activities of the Hotel.")
	}
	
	func recommendedClothingView() -> UIView {
		return lableView(with: "We recommend layered clothing with a good warm jacket or fleece for the colder times of day and for the winter season. Suggested packing list includes walking or hiking shoes, shorts, warmer trousers, sweaters or polar fleece, sun cream (high protection), sun hat and sunglasses. If possible, we recommend a small daypack to carry your personal items during the excursions. Dress code is neat casual for dinner and casual at all other times (no jackets required).")
	}
	
	func electricityView() -> UIView {
		return lableView(with: "Electricity in Chile and Vira Vira is 220V 50Hz and most of the plugs are European two pin round. However, most of the suites also have a couple of US and other wall plugs for the convenience of our guests.")
	}
	
	func languageView() -> UIView {
		return lableView(with: "All of our staff speak Spanish and most of them speak English or some other language. Our guides speak English, Spanish, German or French and if required we can provide excursions also in other languages (on advance notice only).")
	}

	func internetView() -> UIView {
		return lableView(with: "We have installed our own dedicated fiber optics all the way from Pucón to Vira Vira and we can thus offer a reliable and ultra-fast internet (100MB). All public areas and all suites are equipped with LAN and WiFi connections. All have IP telephony with direct international dialing capability.")
	}
	
	func currencyView() -> UIView {
		return lableView(with: "The Chilean currency is the peso however all charges for non-residents are made in USD. Non-residents with proper documentation (immigration slip and passport) are exempt of VAT. We accept Visa, MasterCard, American Express and Diners Club credit cards. ATM’s and currency exchange facilities are available in the village.")
	}
	
	func roomAmenitiesView() -> UIView {
		return lableView(with: "All Suites and Rooms are equipped with:\n- WiFi high-speed internet access (free of charge) - Central heating and air-conditioning\n- Direct international Telephone dialing\n- Hair dryer\n- Safe\nWe do not have television set in our rooms but if required we can provide a PC with fast internet to watch live programs.")
	}
	
	func allInclusivePackageView() -> UIView {
		return lableView(with: "We would like you to fully enjoy your stay with Vira Vira and thus our All Inclusive package is very comprehensive and includes:\n- all transfers from/to Temuco\n- all meals; we provide a daily four course menu and a vegetarian choice. Please advise us ahead of time of any dietary restriction you may have)\n- soft drinks, mineral water, house wine and house beer\n- all offered excursions\n- use of all facilities of the hotel and we are delighted to give you a tour of the Hacienda including a visit to our own cheese and milk diary\nThe All Inclusive package does NOT include:\n- private excursions\n- premium wines and liquors - laundry service\n- telephone calls\n- Spa treatments (massages) - tips")
	}
	
	func excursionView() -> UIView {
		return lableView(with: "We would like to encourage you to explore a new adventure or experience every day and to feel the mystic ambiance of these ancient Mapuche territories. Our guides are passionate about their work, the excursions we offer and are truly excited to share their experience with you.\nEvery day you will meet with our excursion manager to discuss and arrange your next day activities or excursion. Pucón simply offers the best in adventure - be it to explore the many untouched natural parks by horse, to climb with our experienced guide on top of the Volcano, to fight the lively water with your kayak or enjoy a fun day river rafting in the Trancura river - it will always be a fun and unforgettable experience.")
	}
	
	func restaurantView() -> UIView {
		return lableView(with: "Our gourmet cuisine offers a blend of local, ancient indigenous recipes coupled with the best and truly fresh ingredients to serve you that extra dish... Everyday our Chef prepares a four- course menu, carefully composed, lovingly arranged, and accompanied by that special wine to seduce your tastes and senses. For our meat lovers we will gladly grill your favorite steak and for our vegetarians we always have a delicious pasta or a full vegetarian menu to choose from.\nWe offer free seating in our Restaurant (except at full capacity where we will arrange your table) and you are welcome to join your friends or the hotel owner at his or her table.")
	}
	
	func tippingView() -> UIView {
		return lableView(with: "Tips are at the discretion of our guests. We suggest USD 70 – 100 per day to be shared amongst all our team although if you prefer to give a specific amount to your guide or restaurant staff or other individual please do so. Our receptionist will gladly provide you with an envelope.")
	}
	
	func familiesView() -> UIView {
		return lableView(with: "Vira Vira is an ideal place to spend your holiday with your family and children. We offer a broad range of exciting adventures and excursions tailored to families and children. Please note however that lagoons, creeks and a large river surround Vira Vira and we do not have a lifeguard on duty. Most areas are unprotected and we kindly ask you to closely watch your smaller children. We gladly arrange for you on advance notice a babysitter.")
	}
	
	func medicalFacilitiesView() -> UIView {
		return lableView(with: "There is an emergency first aid clinic in the village of Pucón but we recommend using the advanced and modern facilities of the Clinica Alemana in Temuco (1.5 hours away). We advise all our guests to travel with a comprehensive illness and accident insurance policy.")
	}
	
	func lableView(with text: String) -> UIView {
		let view = UIView()
		let label = UILabel()
		
		view.translatesAutoresizingMaskIntoConstraints = false
		label.translatesAutoresizingMaskIntoConstraints = false
		
		label.textColor = UIColor.primary
		label.textAlignment = .justified
		label.numberOfLines = 0
		label.font = label.font.withSize(labelFontSize)
		
		view.addSubview(label)
		label.applyTopAndBottomPinConstraint(toSuperview: 16)
		label.applyCenterXPinConstraint(toSuperview: 0)
		NSLayoutConstraint(item: label, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 0.75, constant: 0).isActive = true
		
		label.text = text
		
		return view
	}

}
