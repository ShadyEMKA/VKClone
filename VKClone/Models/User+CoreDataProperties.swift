//
//  User+CoreDataProperties.swift
//  VKClone
//
//  Created by Андрей Шкундалёв on 27.11.21.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var avatar: String
    @NSManaged public var idProfile: Int
    @NSManaged public var name: String

}

extension User : Identifiable {

}
