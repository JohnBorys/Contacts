//
//  ContactsTableViewCell.swift
//  Contacts
//
//  Created by eOne Bilch Enko on 19.06.18.
//  Copyright © 2018 eOne Bilch Enko. All rights reserved.
//

import UIKit

protocol ContactCellDeligate {
    func didPressedOnUserImageTypeButton(cell: ContactsTableViewCell)
}

class ContactsTableViewCell: UITableViewCell {
    
    
    
    var delegate: ContactCellDeligate?
    
    @IBOutlet weak var imageContactButtonOutlet: UIButton!
    @IBOutlet weak var nameOutlet: UILabel!
    @IBOutlet weak var lastNameOutlet: UILabel!
    @IBOutlet weak var phoneNumberOutlet: UILabel!
    @IBOutlet weak var userImageOutlet: UIImageView!
    

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func onImageTypeButton(_ sender: UIButton) {
        delegate?.didPressedOnUserImageTypeButton(cell: self)
    }
    
}

