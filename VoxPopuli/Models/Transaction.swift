//
//  Transaction.swift
//  VoxPopuli
//
//  Created by Stanislav Kasprik on 12/03/2018.
//  Copyright © 2018 Stanislav Kasprik. All rights reserved.
//

import Foundation

struct Transaction {
    
    var transactionDate: Date
    var amount: Double
    var currency: String
    var type: String
    var correspondingAccountName: String
    var noteForBeneficiary: String
    var constantSymbol: String
    var variableSymbol: String
    var specificSymbol: String
    var note: String
}
