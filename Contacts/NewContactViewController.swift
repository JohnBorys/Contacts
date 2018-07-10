//
//  NewContactViewController.swift
//  Contacts
//
//  Created by eOne Bilch Enko on 19.06.18.
//  Copyright © 2018 eOne Bilch Enko. All rights reserved.
//

import UIKit
import CloudKit

protocol NewContactViewControllerDelegate: class  {
    func didCreatedContactItem(contactItem: ContactUser)
}

class NewContactViewController: UIViewController, UIPickerViewDataSource, UINavigationControllerDelegate, UIPickerViewDelegate, UIImagePickerControllerDelegate {
    
    weak var delegate: NewContactViewControllerDelegate?
    
    var type = RelationshipType.general
    var photo: UIImage? = UIImage(named: "user")
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var photoOnButton: UIButton!
    @IBOutlet weak var relationshipTypePickerView: UIPickerView!
    @IBOutlet weak var emailAddressTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGesture()
        relationshipTypePickerView.selectRow(2, inComponent: 0, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        photoOnButton.layer.cornerRadius = photoOnButton.frame.width/2

    }
    
 //       MARK: - Data Sourse
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
        type = RelationshipType(rawValue: row) ?? .general
    }
    
    @IBAction func addPhotoButton(_ sender: UIButton) {
        let image = UIImagePickerController()
        image.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
        
        image.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        image.allowsEditing = false
        self.present(image, animated: true) {
            self.photoOnButton.setTitle("edit", for: .normal)
            self.photoOnButton.tintColor = UIColor.white
        }
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            photoOnButton.setBackgroundImage(image, for: .normal)
            photoOnButton.contentMode = UIViewContentMode.scaleAspectFill
            photoOnButton.clipsToBounds = true
            photo = image
        } else {
            print("Error image picking")
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onDoneButton(_ sender: UIBarButtonItem) {
        guard let contact = createContact() else {
            let alertController = UIAlertController(title: "Oops", message: "Please, write data correctly", preferredStyle: .alert)
            let okayAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alertController.addAction(okayAction)
            present(alertController, animated: true)
            return
        }
        self.delegate?.didCreatedContactItem(contactItem: contact)
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func onTapGesture() {
        nameTextField.resignFirstResponder()
        lastNameTextField.resignFirstResponder()
        phoneNumberTextField.resignFirstResponder()
    }
    

    private func createContact() -> ContactUser? {
        
        guard let name = nameTextField.text, name.count > 0 else {
            return nil
        }
        guard let lastName = lastNameTextField.text, lastName.count > 0 else {
            return nil
        }
        guard let phoneNumber = phoneNumberTextField.text, phoneNumber.count > 0 else {
            return nil
        }

        let indexOfType = type.rawValue

        var email: String?
        if let newEmail = emailAddressTextField.text, newEmail.count > 0 {
            email = newEmail
        } else {
            email = "testAddress"
        }
        
        let contact: ContactUser = DataManager().save(name: name, lastName: lastName, phoneNumber: phoneNumber, relationshipType: indexOfType, photo: photo, emailAddress: email!)!
        return  contact
    }
    
    private func setupGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTapGesture))
        view.addGestureRecognizer(tapGesture)
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
