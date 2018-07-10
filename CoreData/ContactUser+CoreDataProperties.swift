//
//  ContactUser+CoreDataProperties.swift
//  Contacts
//
//  Created by eOne Bilch Enko on 23.06.18.
//  Copyright © 2018 eOne Bilch Enko. All rights reserved.
//
//

import Foundation
import CoreData


extension ContactUser {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ContactUser> {
        return NSFetchRequest<ContactUser>(entityName: "ContactUser")
    }

    @NSManaged public var lastName: String?
    @NSManaged public var name: String?
    @NSManaged public var phoneNumber: String?
    @NSManaged public var relationshipType: Int16
    @NSManaged public var photo: NSData?
    @NSManaged public var emailAddress: String?
    @NSManaged public var birthday: NSDate?
    @NSManaged public var notes: String?
    @NSManaged public var country: String?
    @NSManaged public var postalCode: Int16
    @NSManaged public var city: String?
    @NSManaged public var street: String?
    @NSManaged public var province: String?

}
