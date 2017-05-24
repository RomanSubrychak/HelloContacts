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

	@IBOutlet weak var tableView: UITableView!
	
	var contacts = [HCContact]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		tableView.delegate = self
		tableView.dataSource = self
		
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
	
	override func setEditing(_ editing: Bool, animated: Bool) {
		super.setEditing(editing, animated: animated)
		
		tableView.setEditing(editing, animated: animated)
	}
	
	
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
		tableView.reloadData()
	}
}

extension ViewController: UITableViewDataSource {
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return contacts.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "contactTableViewCell", for: indexPath) as! ContactTableViewCell
			
		let contact = contacts[indexPath.row]
			
		cell.nameLabel.text = "\(contact.givenName) \(contact.familyName)"
		
		contact.fetchImageIfNeeded()
		if let image = contact.contactImage {
			cell.contactImage.image = image
		}
			
		return cell
	}
	
}

extension ViewController: UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let contact = contacts[indexPath.row]
		
		let alertController = UIAlertController(title: "Contact Tapped", message: "You tapped \(contact.givenName)", preferredStyle: .alert)
		let dismissAction = UIAlertAction(title: "Dismiss", style: .default, handler: { [unowned self]
			action in self.tableView.deselectRow(at: indexPath, animated: true)
		})
		alertController.addAction(dismissAction)
		present(alertController, animated: true)
	}
	
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			contacts.remove(at: indexPath.row)
			//make changes on tableView
			tableView.beginUpdates()
			tableView.deleteRows(at: [indexPath], with: .fade)
			tableView.endUpdates()
		}
	}
	
	func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
		let contact = contacts.remove(at: sourceIndexPath.row)
		contacts.insert(contact, at: destinationIndexPath.row)
	}
}

extension ViewController: UITableViewDataSourcePrefetching {
	
	func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
		for indexPath in indexPaths {
			let contact = contacts[indexPath.row]
			contact.fetchImageIfNeeded()
		}
	}
}
