//
//  BudgetDetailVC.swift
//  BudgetTrack
//
//  Created by Harsh Verma on 19/05/23.
//

import UIKit
import CoreData

class BudgetDetailViewController: UIViewController {
    
    private var persistentContainer: NSPersistentContainer
    private var fetchedResultController: NSFetchedResultsController<Transaction>!
    private var budgetCategory: BudgetCategory
    
    lazy var nameTextField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Transaction name"
        textfield.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textfield.leftViewMode = .always
        textfield.borderStyle = .roundedRect
        return textfield
    }()
    
    lazy var amountTextField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Transaction amount"
        textfield.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textfield.leftViewMode = .always
        textfield.borderStyle = .roundedRect
        return textfield
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TransactionTableViewCell")
        return tableView
    }()
    
    lazy var saveTransactionButton: UIButton = {
        
        var config = UIButton.Configuration.bordered()
        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Save Transaction", for: .normal)
        return button
      
    }()
    
    lazy var errorMessageLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.red
        label.text = ""
        label.numberOfLines = 0
        return label
    }()
    
    lazy var amountLabel: UILabel = {
        let label = UILabel()
        label.text = budgetCategory.amount.formatAsCurrency()
        return label
    }()
    
    lazy var transactionTotalLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    
    init(budgetCategory: BudgetCategory, persistentContainer: NSPersistentContainer) {
        self.budgetCategory = budgetCategory
        self.persistentContainer = persistentContainer
        super.init(nibName: nil, bundle: nil)
        
        let req = Transaction.fetchRequest()
        req.predicate = NSPredicate(format: "category = %@", budgetCategory)
        req.sortDescriptors = [NSSortDescriptor(key: "datecreated", ascending: false)]
        
        fetchedResultController = NSFetchedResultsController(fetchRequest: req, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultController.delegate = self
        
        do {
            try fetchedResultController.performFetch()
        }catch {
            errorMessageLabel.text = "Failed to Fetch Transaction details"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updateTotalTransaction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        
        view.backgroundColor = UIColor.white
        navigationController?.navigationBar.prefersLargeTitles = true
        title = budgetCategory.name
        
        // stackview
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = UIStackView.spacingUseSystem
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
        
        stackView.addArrangedSubview(amountLabel)
        stackView.setCustomSpacing(50, after: amountLabel)
        stackView.addArrangedSubview(nameTextField)
        stackView.addArrangedSubview(amountTextField)
        stackView.addArrangedSubview(saveTransactionButton)
        stackView.addArrangedSubview(errorMessageLabel)
        stackView.addArrangedSubview(transactionTotalLabel)
        stackView.addArrangedSubview(tableView)
        
        view.addSubview(stackView)
        
        // add constraints
        nameTextField.widthAnchor.constraint(equalToConstant: 200).isActive = true
        amountTextField.widthAnchor.constraint(equalToConstant: 200).isActive = true
        saveTransactionButton.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
        
        saveTransactionButton.addTarget(self, action: #selector(didPressSaveTransaction), for: .touchUpInside)
        
        stackView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        
        tableView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        tableView.heightAnchor.constraint(equalToConstant: 600).isActive = true
        
    }
    
    
    private var validateDataEntry: Bool {
        guard let name = nameTextField.text, let amt = amountTextField.text else {
            return false
        }
        return !name.isEmpty && !amt.isEmpty && amt.isNumeric && amt.isGreaterThan(0)
    }
    
    
    @objc func didPressSaveTransaction() {
        if validateDataEntry {
            saveTransaction()
            
            print("Saved to Model")
        }else {
            errorMessageLabel.text = "Failed to save transactions!"
        }
    }
    
    private func saveTransaction() {
        guard let name = nameTextField.text, let amount = amountTextField.text else {
            return
        }
        
        let transaction = Transaction(context: persistentContainer.viewContext)
        transaction.name = name
        transaction.amount = Double(amount) ?? 0.0
        transaction.datecreated = Date()
        
        budgetCategory.addToTransactions(transaction)
        
        do  {
            try persistentContainer.viewContext.save()
            nameTextField.text = ""
            amountTextField.text = ""
            errorMessageLabel.text = ""
            tableView.reloadData()
        }catch {
            errorMessageLabel.text = "Failed!"
        }
    }
//    
//    var totalTransaction: Double {
//        let transact = fetchedResultController.fetchedObjects ?? []
//        return transact.reduce(0) { next, transaction in
//            next + transaction.amount
//        }
//    }
    
    private func updateTotalTransaction() {
      //  transactionTotalLabel.text = totalTransaction.formatAsCurrency()
        transactionTotalLabel.text = budgetCategory.totalTransaction.formatAsCurrency()
    }
    
    private func deleteTransactions(_ transaction: Transaction) {
        persistentContainer.viewContext.delete(transaction)
        
        do {
            try persistentContainer.viewContext.save()
        }catch {
            errorMessageLabel.text = "Failed to delete Transaction"
        }
    }
    
}

extension BudgetDetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (fetchedResultController.fetchedObjects ?? []).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionTableViewCell", for: indexPath)
        let trans = fetchedResultController.object(at: indexPath)
        var config = cell.defaultContentConfiguration()
        config.text = trans.name
        config.secondaryText = trans.amount.formatAsCurrency()
        cell.contentConfiguration = config
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let transacts = fetchedResultController.object(at: indexPath)
            deleteTransactions(transacts)
        }
    }
    
}


extension BudgetDetailViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        updateTotalTransaction()
        tableView.reloadData()
    }
}
