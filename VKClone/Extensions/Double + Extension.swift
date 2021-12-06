//
//  Double + Extension.swift
//  VKClone
//
//  Created by Андрей Шкундалёв on 6.12.21.
//

import Foundation

extension Double {
    
    func dateFormat() -> String {
        let df = DateFormatter()
        df.locale = Locale(identifier: "ru_RU")
        df.dateFormat = "d MMM 'в' HH:mm"
        let date = Date(timeIntervalSince1970: self)
        return df.string(from: date)
    }
}
