//
//  ViewController.swift
//  HelloContacts
//
//  Created by Roman Subrichak on 5/20/17.
//  Copyright © 2017 Roman Subrychak. All rights reserved.
//

import UIKit
import Contacts

class ViewController: UIViewController {

	@IBOutlet weak var collectionView: UICollectionView!

	var contacts = [HCContact]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		collectionView.dataSource = self
		collectionView.delegate = self
		//collectionView.prefetchDataSource = self
		
		let store = CNContactStore()
		
		if CNContactStore.authorizationStatus(for: .contacts) == .notDetermined {
			store.requestAccess(for: .contacts, completionHandler: {
				[weak self] authorized, error in
				if authorized {
					self?.retrieveContacts(fromStore: store)
				}
			})
		} else {
			retrieveContacts(fromStore: store)
		}
		
		navigationItem.rightBarButtonItem = editButtonItem
	}
	
//	override func setEditing(_ editing: Bool, animated: Bool) {
//		super.setEditing(editing, animated: animated)
//		collectionView.setEditing(editing, animated: animated)
//	}
	
	func retrieveContacts(fromStore store: CNContactStore) {
		let keysToFetch = [CNContactGivenNameKey as CNKeyDescriptor,
		                   CNContactFamilyNameKey as CNKeyDescriptor,
		                   CNContactImageDataKey as CNKeyDescriptor,
		                   CNContactImageDataAvailableKey as CNKeyDescriptor]
		let containerId = store.defaultContainerIdentifier()
		let predicate = CNContact.predicateForContactsInContainer(withIdentifier: containerId)
		contacts = try! store.unifiedContacts(matching: predicate, keysToFetch: keysToFetch).map({
			HCContact(contact: $0)
		})
	}
}

extension ViewController: UICollectionViewDataSource {
	
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return contacts.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "contactCell", for: indexPath) as? ContactCollectionCell else {
			return UICollectionViewCell()
		}
		
		let contact = contacts[indexPath.item]
		
		cell.nameLabel.text = "\(contact.givenName) \(contact.familyName)"
		
		contact.fetchImageIfNeeded()
		cell.contactImage.image = contact.contactImage
		return cell
	}
}

extension ViewController: UICollectionViewDelegate {
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		
		let contact = contacts[indexPath.item]
		
		let alertController = UIAlertController(title: "You selected", message: "\(contact.givenName) \(contact.familyName)", preferredStyle: .alert)
		
		let okAction = UIAlertAction(title: "OK", style: .destructive)
		alertController.addAction(okAction)
		
		present(alertController, animated: true)
	}
	
	func collectionView(_ collectionView: UICollectionView, moveFrom source: IndexPath, to destination: IndexPath) {
		let contact = contacts.remove(at: source.item)
		contacts.insert(contact, at: destination.item)
	}
}
