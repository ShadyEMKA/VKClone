//
//  NetworkError.swift
//  VKClone
//
//  Created by Андрей Шкундалёв on 13.11.21.
//

import Foundation

enum NetworkError {
    
    case errorServer
    case errorDecodeJSON
    case unknownError
}

extension NetworkError: LocalizedError {
    
    var errorDescription: String? {
        switch self {
        case .errorServer:
            return NSLocalizedString("Ошибка сервера", comment: "Проверьте соединение с сетью")
        case .unknownError:
            return NSLocalizedString("Неизвестная ошибка", comment: "Обратитесь в службу поддержки")
        case .errorDecodeJSON:
            return NSLocalizedString("Ошибка парсинга", comment: "Обратитесь в службу поддержки")
        }
    }
}
