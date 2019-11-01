//
//  RemoveButtonFooterViewTableViewCell.swift
//  BudTechTest
//
//  Created by Azhar Islam on 31/10/2019.
//  Copyright © 2019 Azhar Islam. All rights reserved.
//

import UIKit

protocol RemoveButtonViewProtocol: AnyObject {
    func setAction(action: @escaping () -> Void)
    func set(isHidden: Bool)
}

class RemoveButtonFooterViewTableViewCell: UITableViewCell {
    
    static let height: CGFloat = 100

    @IBOutlet weak var removeButton: UIButton!
    var buttonPressed: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func removeButtonPressed(_ sender: Any) {
        buttonPressed?()
    }
}

extension RemoveButtonFooterViewTableViewCell: RemoveButtonViewProtocol {
    func setAction(action: @escaping () -> Void) {
        self.buttonPressed = action
    }
    
    func set(isHidden: Bool) {
        self.removeButton.isHidden = isHidden
    }
}
