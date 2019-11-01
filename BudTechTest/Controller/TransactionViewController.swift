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
    var items = [Transactions]()
    var isTapped: Bool?
    var isEditingCells = false
    
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
        tableView.allowsSelection = false
    }
    
    @IBAction func editAction(_ sender: UIBarButtonItem) {
        isEditingCells = !isEditingCells
        sender.title = isEditingCells ? titleStrings.done : titleStrings.edit
        removeButton.isHidden = !isEditingCells
        tableView.allowsMultipleSelection = isEditingCells
        tableView.allowsSelection = isEditingCells
    }
    
    @IBAction func removeCellTapped(_ sender: Any) {
        
        //  The best way to present this would have been to configure the didSelect tableView items and call a delegate that receives the call that a user has selected a row, then do the logic of comparing the two arrays and then add the action inside this. Struggled with doing that efficienty so found a way to delete the items in a hacky way
        
        //  Another thing I did initially was use the editingStyle = .delete on tableView delegate but this only allowed me to swipe and delete which didn't meet requirement
        
        if let selectedRows = tableView.indexPathsForSelectedRows {
            let sortedPaths = selectedRows.sorted {$0.row > $1.row}
            for indexPath in sortedPaths {
                let transactionCount = transactions.count
                let index = transactionCount - 1
                for index in stride(from: index, through: 0, by: -1) {
                    if(indexPath.row == index){
                        transactions.remove(at: index)
                    }
                }
            }
            tableView.deleteRows(at: sortedPaths, with: .automatic)
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
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
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
        
        //  the right way of doing the image load on tableView is using a URLSession dataTask, and have a reference for those dataTasks that you can .cancel() as soon as the cell scrolls out of view but I struggled to implement this correctly
        
        
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
}
