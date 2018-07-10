//
//  ViewController.swift
//  Contacts
//
//  Created by eOne Bilch Enko on 19.06.18.
//  Copyright © 2018 eOne Bilch Enko. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var contactUsers: [ContactUser] = []
    
    @IBOutlet weak var contactsTableView: UITableView!
    @IBOutlet weak var topSearchBarConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchBarTextfield: UISearchBar!
    
    
    var array: [String] = []
    
    @IBAction func onSearshButton(_ sender: Any) {
        //topSearchBarConstraint.constant = 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let cellNib = UINib(nibName: "\(ContactsTableViewCell.self)", bundle: nil)
        contactsTableView.register(cellNib, forCellReuseIdentifier: "\(ContactsTableViewCell.self)")
        
        
        //    topSearchBarConstraint.constant = -56
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        contactUsers = DataManager().loadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let destinationViewController = segue.destination as? NewContactViewController {
            destinationViewController.delegate = self
        }
        //        if let dvc = segue.destination as? DetailContactViewController {
        //
        //        }
        
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = contactsTableView.dequeueReusableCell(withIdentifier: "\(ContactsTableViewCell.self)") as! ContactsTableViewCell
        let currentUser = contactUsers[indexPath.row]
        cell.selectionStyle = .none
        cell.userImageOutlet.layer.cornerRadius = cell.userImageOutlet.frame.height / 2
        
        let currentRelationship = RelationshipType(rawValue: Int(currentUser.relationshipType))
        let photo = currentRelationship?.getImage()
        
        cell.nameOutlet.text = currentUser.name
        cell.lastNameOutlet.text = currentUser.lastName
        cell.phoneNumberOutlet.text = currentUser.phoneNumber
        if let contactPhoto = currentUser.photo {
            cell.userImageOutlet.image = UIImage(data: contactPhoto as Data, scale:1.0)
        } else {
            cell.userImageOutlet.image = UIImage(named: "user")
        }
        
        cell.imageContactButtonOutlet.setBackgroundImage(photo, for: .normal)
        //        cell.imageContactOutlet.image = currentUser.userImage
        cell.delegate = self
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let segueStorybord = UIStoryboard(name: "Main", bundle: nil)
        if let viewController = segueStorybord.instantiateViewController(withIdentifier: "detailContactStorybord") as? DetailContactViewController {
            
            let currentUser = contactUsers[indexPath.row]
            if let contactPhoto = currentUser.photo {
                viewController.photo = UIImage(data: contactPhoto as Data, scale:1.0)
            } else {
                viewController.photo = UIImage(named: "user")
            }
            viewController.currentUser = currentUser
            viewController.tableView = tableView
            viewController.emailAddress = currentUser.emailAddress
            viewController.name = currentUser.name
            viewController.lastName = currentUser.lastName
            viewController.phoneNumber = currentUser.phoneNumber
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        //TODO: - deleting by id
        DataManager().delete(objectID: contactUsers[indexPath.row].objectID)   // Deleting contact ithem by objectID
        
        if editingStyle == .delete {
            self.contactUsers.remove(at: indexPath.row)
            
        }
        
        tableView.reloadData()
    }
    
}



extension ViewController: ContactCellDeligate {
    
    func didPressedOnUserImageTypeButton(cell: ContactsTableViewCell) {
        guard let indexPathSelectedCell = contactsTableView.indexPath(for: cell) else {
            return
        }
        let currentUserContact = contactUsers[indexPathSelectedCell.row]
        
        let currentRawValue = currentUserContact.relationshipType.hashValue
        let newRelationshipType = RelationshipType(rawValue: currentRawValue + 1) ?? RelationshipType(rawValue: 0)
        guard let _newRelationshipType = newRelationshipType else {
            return
        }
        currentUserContact.relationshipType = Int16(_newRelationshipType.rawValue)
        DataManager().editContact(contact: currentUserContact, relationshipType: _newRelationshipType.rawValue)
        
        contactsTableView.reloadRows(at: [indexPathSelectedCell], with: .automatic)
    }
}


extension ViewController: NewContactViewControllerDelegate {
    func didCreatedContactItem(contactItem: ContactUser) {
        contactUsers.append(contactItem)
        contactsTableView.reloadData()
    }
}

