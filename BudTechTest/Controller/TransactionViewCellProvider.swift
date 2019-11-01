//
//  TransactionViewCellProvider.swift
//  BudTechTest
//
//  Created by Azhar Islam on 31/10/2019.
//  Copyright © 2019 Azhar Islam. All rights reserved.
//

import Foundation
import UIKit

struct TransactionViewCellProvider {
    let vc: TransactionViewController

    enum Section {
        case cell
//        case button

        init(index: Int) {
            switch index {
//            case 0: self = .cell
            default: self = .cell
//            default: self = .button
            }
        }
    }

    private let sections: [Section] = [.cell] //, .button

    func register(on tableView: UITableView?) {
        
        tableView?.register(UINib(nibName: "TransactionViewCell", bundle: nil), forCellReuseIdentifier: "TransCell")
//        tableView?.register(UINib(nibName: "RemoveButtonFooterViewTableViewCell", bundle: nil), forCellReuseIdentifier: "RemoveCell")
    }
    
    func cell(tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        switch Section(index: indexPath.section) {
        case .cell:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TransCell", for: indexPath) as? TransactionViewCell else {
                fatalError("Could not deque cell")
            }
            vc.configureTransactionCell(at: indexPath.row, cell: cell)
            return cell
//        case .button:
//            guard let cell = tableView.dequeueReusableCell(withIdentifier: "RemoveCell", for: indexPath) as? RemoveButtonFooterViewTableViewCell else {
//                fatalError("Could not deque cell")
//            }
//            vc.configureRemoveButtonCell(cell: cell)
//            return cell
        }
    }
    
    func numberOfSections() -> Int {
        return sections.count
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        switch Section(index: section) {
        case .cell:
            return vc.transactions.count
        }
//        case .button:
//            return 1
//        }
    }
    
    func height(at indexPath: IndexPath) -> CGFloat {
        switch Section(index: indexPath.section) {
        case .cell:
            return TransactionViewCell.height
//        case .button:
//            return RemoveButtonFooterViewTableViewCell.height
        }
    }
}
