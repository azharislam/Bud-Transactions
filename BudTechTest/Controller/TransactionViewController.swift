//
//  ViewController.swift
//  BudTechTest
//
//  Created by Azhar Islam on 31/10/2019.
//  Copyright © 2019 Azhar Islam. All rights reserved.
//

import UIKit

enum titleStrings {
    static let edit: String = "Edit"
    static let done: String = "Done"
    static let transactions: String = "Transactions"
    static let remove: String = "Remove"
}

protocol TransactionViewControllerProtocol: AnyObject {
    func reloadData()
    func setNavTitle(_ title: String)
    func setNavigation()
    func configureTransactionCell(at index: Int, cell: TransactionViewCellProtocol)
    func setRemoveButtonTitle(_ title: String)
//    func configureRemoveButtonCell(cell: RemoveButtonViewProtocol)
}

class TransactionViewController: UIViewController {
    
    @IBOutlet weak var removeButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var editButton: UIBarButtonItem!
    private lazy var cellProvider: TransactionViewCellProvider = {
           return TransactionViewCellProvider(vc: self)
       }()
    var transactions = [Transactions]()
    var removeButtonHidden: Bool = false
    
    
    final let url = URL(string: "http://www.mocky.io/v2/5b36325b340000f60cf88903")

    override func viewDidLoad() {
        super.viewDidLoad()
        self.downloadJSON()
        tableView?.dataSource = self
        cellProvider.register(on: tableView)
        self.tableView.rowHeight = TransactionViewCell.height
        self.removeButton.isHidden = true
        self.setNavigation()
        self.setNavTitle(titleStrings.transactions)
        self.setRemoveButtonTitle(titleStrings.remove)
    }
    
    @IBAction func editAction(_ sender: UIBarButtonItem) {
        self.tableView.isEditing = !self.tableView.isEditing
        sender.title = self.tableView.isEditing ? titleStrings.done : titleStrings.edit
        
        if sender.title == titleStrings.done {
            removeButton.isHidden = false
            tableView.allowsSelection = true
            tableView.allowsMultipleSelection = true
        } else {
            removeButton.isHidden = true
            tableView.allowsSelection = false
        }
        
    }
    
    @IBAction func removeCellTapped(_ sender: Any) {
        if let selectedRows = tableView.indexPathsForSelectedRows {
            
            var items = [Transactions]()
            for indexPath in selectedRows  {
                items.append(transactions[indexPath.row])
            }
//            for item in items {
//                if let index = transactions.first {
//                    transactions.remove(at: index(item))
//                }
//            }
            tableView.beginUpdates()
            tableView.deleteRows(at: selectedRows, with: .automatic)
            tableView.endUpdates()
        }
    }
    
    func downloadJSON() {
        guard let downloadURL = url else {return}
        URLSession.shared.dataTask(with: downloadURL) { data, urlResponse, error in
            guard let data = data, error == nil, urlResponse != nil else {
                print("Error downloading JSON file")
                return
            }
            print("Succesfully downloaded JSON file")
            do
            {
                let decoder = JSONDecoder()
                let downloadedTransactions = try decoder.decode(TransactionModel.self, from: data)
                self.transactions = downloadedTransactions.data
                print("Success")
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch {
                print(error)
                print("Error while trying to download")
            }
        }.resume()
    }
}

extension TransactionViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellProvider.numberOfRowsInSection(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cellProvider.cell(tableView: tableView, at: indexPath)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return cellProvider.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            transactions.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

extension TransactionViewController: TransactionViewControllerProtocol {
    func setRemoveButtonTitle(_ title: String) {
        self.removeButton.titleLabel?.text = title
    }
    
    func reloadData() {
        tableView.reloadData()
    }
    
    func setNavTitle(_ title: String) {
        self.navigationItem.title = title
    }
    
    func setNavigation() {
        self.editButton.tintColor = UIColor.white
        self.navigationController?.navigationBar.barTintColor = UIColor.black
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    func configureTransactionCell(at index: Int, cell: TransactionViewCellProtocol) {
        cell.set(transactionTitle: transactions[index].description)
        cell.set(categoryTitle: transactions[index].category)
        cell.set(priceLabel: String(format: "£%.2f", transactions[index].amount.value))
        
        if  let imageURL = URL(string: transactions[index].product.icon) {
                DispatchQueue.global().async {
                    let data = try? Data(contentsOf: imageURL)
                    if let data = data {
                        if let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            cell.set(image: image)
                        }
                        }
                }
            }
        }
    }
       
//    func configureRemoveButtonCell(cell: RemoveButtonViewProtocol) {
//       
//        if !self.tableView.isEditing {
//            self.editButton.title = buttonNames.edit
//            cell.set(isHidden: true)
//        } else {
//            self.editButton.title = buttonNames.done
//            self.tableView.allowsMultipleSelection = true
//            cell.set(isHidden: false)
//            cell.setAction(action: { [weak self] in
//                guard let transRow = self?.transactions else {return}
//                if let selectedRows = self?.tableView.indexPathsForSelectedRows {
//                var tmp = [Transactions]()
//                for index in selectedRows {
//                    tmp.append(transRow[index.row])
//                }
//
//                for newTmp in tmp {
//                    guard let endIndex = self?.transactions.endIndex else {return}
//                    transactions.remove(at: endIndex)
//                    }
//
//                }
//            })
//        }
        
//        cell.setAction(action: [weak self] in
//            if(self.tablevi)
//
//
//        cell.setAction {
//            if (!self.tableView.isEditing) {
//                self.editButton.title = "Edit"
//                cell.set(isHidden: true)
//                cell.setAction {
//
//                }
//            } else {
//                self.editButton.title = "Done"
//                self.tableView.allowsMultipleSelection = true
//                cell.set(isHidden: false)
//            }
//        }
//    }
}
