//
//  HCContact.swift
//  HelloContacts
//
//  Created by Roman Subrichak on 5/21/17.
//  Copyright © 2017 Roman Subrychak. All rights reserved.
//

import UIKit
import Contacts

class HCContact {
	
	private let contact: CNContact
	var contactImage: UIImage?
	
	var givenName: String {
		return contact.givenName
	}
	
	var familyName: String {
		return contact.familyName
	}
	
	init(contact: CNContact) {
		self.contact = contact
	}
	
	func fetchImageIfNeeded() {
		if let imageData = contact.imageData, contactImage == nil {
			contactImage = UIImage(data: imageData)
		}
	}
}
