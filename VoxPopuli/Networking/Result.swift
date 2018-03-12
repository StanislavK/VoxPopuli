//
//  Result.swift
//  VoxPopuli
//
//  Created by Stanislav Kasprik on 12/03/2018.
//  Copyright © 2018 Stanislav Kasprik. All rights reserved.
//

enum Result<Value> {
    case success(Value)
    case failure(Error?)
}

// Result helpers
extension Result {
    
    init(_ value: Value?, or error: Error?) {
        if let value = value {
            self = .success(value)
        } else {
            self = .failure(error)
        }
    }
    
    var value: Value? {
        guard case .success(let v) = self else { return nil }
        return v
    }
}
