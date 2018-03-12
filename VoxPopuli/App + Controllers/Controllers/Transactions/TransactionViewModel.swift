//
//  TransactionViewModel.swift
//  VoxPopuli
//
//  Created by Stanislav Kasprik on 12/03/2018.
//  Copyright © 2018 Stanislav Kasprik. All rights reserved.
//

import Foundation

final class TransactionViewModel {
    
    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        
        return dateFormatter
    }()
    
    let messageToBeneficiary: String
    let account: String
    private let transactionDate: Date
    
    init(_ transaction: Transaction) {
        messageToBeneficiary = transaction.noteForBeneficiary
        account = transaction.correspondingAccountName
        transactionDate = transaction.transactionDate
    }
    
    var dateString: String {
        return dateFormatter.string(from: transactionDate)
    }
}
