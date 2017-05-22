//
//  ContactTableViewCell.swift
//  HelloContacts
//
//  Created by Roman Subrichak on 5/21/17.
//  Copyright © 2017 Roman Subrychak. All rights reserved.
//

import UIKit

class ContactTableViewCell: UITableViewCell {

	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var contactImage: UIImageView!
	
	override func prepareForReuse() {
		super.prepareForReuse()
		
		contactImage.image = nil
	}

}
