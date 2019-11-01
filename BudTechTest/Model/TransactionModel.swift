//
//  TransactionModel.swift
//  BudTechTest
//
//  Created by Azhar Islam on 31/10/2019.
//  Copyright © 2019 Azhar Islam. All rights reserved.
//

import Foundation
import UIKit

struct TransactionModel: Codable {
    let data: [Transactions]
    
    init(data: [Transactions]) {
        self.data = data
    }
}

struct Transactions: Codable {
    let id: String
    let date: String
    let description: String
    let category: String
    let currency: String
    let amount: Amount
    let product: Product
}

struct Amount: Codable {
    let value: Double
    let currency_iso: String
}

struct Product: Codable {
    let id: Int
    let title: String
    let icon: String
}
