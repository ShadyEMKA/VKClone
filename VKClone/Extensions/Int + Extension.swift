//
//  Int + Extension.swift
//  VKClone
//
//  Created by Андрей Шкундалёв on 6.12.21.
//

import Foundation

extension Int {
    
    func reviewCountForNew() -> String {
        guard self != 0 else { return "" }
        var str = String(self)
        if 4...6 ~= str.count {
            str = str.dropLast(3) + "K"
        } else if str.count > 6 {
            str = str.dropLast(6) + "M"
        }
        return str
    }
}
