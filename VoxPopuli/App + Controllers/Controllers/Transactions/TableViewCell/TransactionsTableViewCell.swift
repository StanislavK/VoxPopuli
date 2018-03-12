//
//  TransactionsTableViewCell.swift
//  VoxPopuli
//
//  Created by Stanislav Kasprik on 11/03/2018.
//  Copyright © 2018 Stanislav Kasprik. All rights reserved.
//

import UIKit

final class TransactionsTableViewCell: UITableViewCell {
    
    // MARK: - IB Outlets
    
    @IBOutlet weak var messageForBeneficiaryLabel: UILabel!
    @IBOutlet weak var accountLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

    // TODO: Add more details
    var model: TransactionViewModel? {
        didSet {
            guard let model = model else {
                return
            }
            messageForBeneficiaryLabel.text = model.messageToBeneficiary
            accountLabel.text = model.account
            dateLabel.text = model.dateString
        }
    }
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }

    override func awakeFromNib() {
        super.awakeFromNib()

    }

}
