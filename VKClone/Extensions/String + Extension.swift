//
//  String + Extension.swift
//  VKClone
//
//  Created by Андрей Шкундалёв on 19.11.21.
//

import UIKit

extension String {
    
    func height(width: CGFloat, font: UIFont?) -> CGFloat {
        let textSize = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        
        guard let font = font else {
            return 0
        }

        let size = self.boundingRect(with: textSize,
                                     options: .usesLineFragmentOrigin,
                                     attributes: [NSAttributedString.Key.font : font],
                                     context: nil)
        return ceil(size.height)
    }
}
