//
//  UIColor + Extension.swift
//  VKClone
//
//  Created by Андрей Шкундалёв on 31.10.21.
//

import UIKit

extension UIColor {
    //шапка, иконки
    static func headerAndButton() -> UIColor {
        return UIColor(displayP3Red: 65/255, green: 105/255, blue: 172/255, alpha: 1)
    }
    //фон
    static func mainWhite() -> UIColor {
        return UIColor(displayP3Red: 230/255, green: 232/255, blue: 236/255, alpha: 1)
    }
    //фон кнопок
    static func supportWhite() -> UIColor {
        return UIColor(displayP3Red: 245/255, green: 245/255, blue: 246/255, alpha: 1)
    }
    //текст
    static func text() -> UIColor {
        return UIColor(displayP3Red: 1/255, green: 1/255, blue: 1/255, alpha: 1)
    }
    //приглушенный черный
    static func blackMuted() -> UIColor {
        return UIColor(displayP3Red: 33/255, green: 34/255, blue: 34/255, alpha: 1)
    }
    //надписи
    static func lettering() -> UIColor {
        return UIColor(displayP3Red: 94/255, green: 98/255, blue: 101/255, alpha: 1)
    }
    //подписи
    static func signatures() -> UIColor {
        return UIColor(displayP3Red: 126/255, green: 129/255, blue: 135/255, alpha: 1)
    }
    //плейсхолдер
    static func textFieldPlaceholder() -> UIColor {
        return UIColor(displayP3Red: 230/255, green: 232/255, blue: 236/255, alpha: 1)
    }
    
    static func tabBarItem() -> UIColor {
        return UIColor(displayP3Red: 76/255, green: 132/255, blue: 226/255, alpha: 1)
    }
    
    static func tabBarUnselectedItem() -> UIColor {
        return UIColor(displayP3Red: 136/255, green: 144/255, blue: 157/255, alpha: 1)
    }
}
