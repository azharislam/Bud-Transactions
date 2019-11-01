//
//  TransactionViewCell.swift
//  BudTechTest
//
//  Created by Azhar Islam on 31/10/2019.
//  Copyright © 2019 Azhar Islam. All rights reserved.
//

import UIKit

protocol TransactionViewCellProtocol: AnyObject {
    func set(transactionTitle: String)
    func set(categoryTitle: String)
    func set(image: UIImage?)
    func set(priceLabel: String)
}

class TransactionViewCell: UITableViewCell {
    
    static let height: CGFloat = 76

    @IBOutlet weak var logoView: UIImageView!
    @IBOutlet weak var transLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var contentCellView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configureImageShape()
        self.formatLabels()
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        if highlighted {
            contentCellView.backgroundColor = .clear
        }
    }

    func configureImageShape() {
        logoView.layer.masksToBounds = true
        logoView.layer.borderWidth = 1.5
        logoView.layer.borderColor = UIColor.lightGray.cgColor
        logoView.layer.cornerRadius = logoView.bounds.width / 2
    }
       
    func formatLabels() {
        transLabel.font = UIFont.boldSystemFont(ofSize: 16.0)
        amountLabel.font = UIFont.boldSystemFont(ofSize: 16.0)
        categoryLabel.textColor = UIColor.gray
    }
    
}

extension TransactionViewCell: TransactionViewCellProtocol {
    func set(transactionTitle: String) {
        self.transLabel.text = transactionTitle
    }
    
    func set(categoryTitle: String) {
        self.categoryLabel.text = categoryTitle
    }
    
    func set(image: UIImage?) {
        self.logoView.image = image
    }
    
    func set(priceLabel: String) {
        self.amountLabel.text = priceLabel
    }
}
