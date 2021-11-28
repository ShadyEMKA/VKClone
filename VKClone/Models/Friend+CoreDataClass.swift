//
//  Friend+CoreDataClass.swift
//  VKClone
//
//  Created by Андрей Шкундалёв on 27.11.21.
//
//

import Foundation
import CoreData

@objc(Friend)
public class Friend: NSManagedObject {

    func contains(searchText: String?) -> Bool {
        guard let filter = searchText,
              !filter.isEmpty else { return true }
        let filterLower = filter.lowercased()
        return name.lowercased().contains(filterLower)
    }
}
