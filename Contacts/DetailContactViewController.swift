//
//  DetailContactViewController.swift
//  Contacts
//
//  Created by eOne Bilch Enko on 21.06.18.
//  Copyright © 2018 eOne Bilch Enko. All rights reserved.
//

import UIKit

protocol DetailContactViewControllerDelegate: class {
    func didEditedContactItem(contactItem: ContactUser)
}

class DetailContactViewController: UIViewController, UIImagePickerControllerDelegate, UIPickerViewDataSource, UINavigationControllerDelegate, UIPickerViewDelegate {
    
    
    weak var delegate: DetailContactViewController?
    
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var emailAddressLabel: UILabel!
    @IBOutlet weak var relationshipTypeLabel: UILabel!
    @IBOutlet weak var relationshipTypeImageView: UIImageView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var editButtonOutlet: UIBarButtonItem!
    @IBOutlet weak var steckViewForSave: UIStackView!
    @IBOutlet weak var photoOnButton: UIButton!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var eMailAddressTextField: UITextField!
    @IBOutlet weak var pickerViewForSave: UIPickerView!
    
    var type = RelationshipType.general

    
    var currentUser: ContactUser?
    var tableView: UITableView?
    
    var photo: UIImage?
    var currentPhoto: UIImage?
    var name: String?
    var lastName: String?
    var phoneNumber: String?
    var emailAddress: String?
    var fullName: String {
        var optionalFullName = ""
        if let optionalName = name, let optionalLastName = lastName {
            optionalFullName = optionalName + " " + optionalLastName
        }
        return optionalFullName
    }
    
    override func viewWillAppear(_ animated: Bool) {
        photoImageView.image = photo
        
        photoOnButton.setBackgroundImage(photo, for: .normal)
        
        fullNameLabel.text = fullName
        phoneNumberLabel.text = currentUser?.phoneNumber
        if let email = currentUser?.emailAddress {
            emailAddressLabel.text = "Email Address: " + email
        } else {
            emailAddressLabel.text = nil
        }
        let indexOfcurrentRelationship = currentUser?.relationshipType.hashValue
        let textOfCurrentRelationship = RelationshipType(rawValue: indexOfcurrentRelationship!)?.getNameType()
        relationshipTypeLabel.text = relationshipTypeLabel.text! + ": " + textOfCurrentRelationship!
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        photoImageView.layer.cornerRadius = photoImageView.frame.width / 2
        photoOnButton.layer.cornerRadius = photoOnButton.frame.height / 2
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photoImageView.contentMode = UIViewContentMode.scaleAspectFill
        photoImageView.clipsToBounds = true
        photoOnButton.clipsToBounds = true
        
        // TODO: - set cornerRadius
//        photoOnButton.layer.cornerRadius = photoOnButton.frame.width / 2
        
        pickerViewForSave.selectRow((currentUser?.relationshipType.hashValue)!, inComponent: 0, animated: true)
        
        nameTextField.text = currentUser?.name
        lastNameTextField.text = currentUser?.lastName
        phoneNumberTextField.text = currentUser?.phoneNumber
        eMailAddressTextField.text = currentUser?.emailAddress

//        addPhotoForSave.setBackgroundImage(photo, for: ) {
//            addPhotoForSave.setTitle("edit", for: .normal)
//            addPhotoForSave.tintColor = UIColor.white
//        }
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return RelationshipType.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return RelationshipType(rawValue: row)?.getNameType()
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        type = RelationshipType(rawValue: row - 1) ?? .general
    }
    
    @IBAction func onPhotoButton(_ sender: Any) {
        let image = UIImagePickerController()
        image.delegate = self
        
        image.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        image.allowsEditing = false
        self.present(image, animated: true) {
            self.photoOnButton.setTitle("edit", for: .normal)
            self.photoOnButton.tintColor = UIColor.white
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            photo = image
            photoOnButton.setBackgroundImage(photo, for: .normal)
            photoOnButton.contentMode = UIViewContentMode.scaleAspectFill
            photoOnButton.clipsToBounds = true
        } else {
            print("Error image picking")
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func saveButton(sender: UIBarButtonItem) {
        print("Saved")
        DataManager().editContact(contact: currentUser!, name: nameTextField.text, lastName: lastNameTextField.text, phoneNumber: phoneNumberTextField.text, photo: photo, emailAddress: eMailAddressTextField.text)
        self.navigationController?.popViewController(animated: true)
        tableView?.reloadData()
    }

    @IBAction func onEditButton(_ sender: Any) {
        photoImageView.isHidden = true
        fullNameLabel.isHidden = true
        stackView.isHidden = true
        
        steckViewForSave.isHidden = false
        pickerViewForSave.isHidden = false
        photoOnButton.isHidden = false
        
        
        self.navigationItem.rightBarButtonItem = nil
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveButton(sender:)))
        
        nameTextField.text = name
        lastNameTextField.text = lastName
        
    }
    

}
