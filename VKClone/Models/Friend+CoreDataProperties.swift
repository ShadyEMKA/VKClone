//
//  Friend+CoreDataProperties.swift
//  VKClone
//
//  Created by Андрей Шкундалёв on 27.11.21.
//
//

import Foundation
import CoreData


extension Friend: FriendViewModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Friend> {
        return NSFetchRequest<Friend>(entityName: "Friend")
    }

    @NSManaged public var idProfile: Int
    @NSManaged public var mainPhoto: String
    @NSManaged public var name: String
    @NSManaged public var online: Bool
    @NSManaged public var recommend: Bool

}

extension Friend : Identifiable {

}
