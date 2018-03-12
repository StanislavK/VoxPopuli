//
//  NetworkingError.swift
//  VoxPopuli
//
//  Created by Stanislav Kasprik on 12/03/2018.
//  Copyright © 2018 Stanislav Kasprik. All rights reserved.
//

import Foundation

enum NetworkingError: Error {
    case incorrectStatusCode
    case unknownStatusCode
    case missingData
    case unknown
}

extension NetworkingError: LocalizedError {
    
    public var errorDescription: String? {
        switch self {
        case .incorrectStatusCode: return "Incorrect status code"
        case .unknownStatusCode: return "Unknown status code"
        case .missingData: return "Missing data"
        case .unknown: return "Unknown"
        }
    }
}
