//
//  ViewController.swift
//  BudgetTrack
//
//  Created by Harsh Verma on 13/05/23.
//

import UIKit
import CoreData

class ViewController: UITableViewController {

    //MARK: - Properties
    private var persistentContainer: NSPersistentContainer
    private var fetchResult: NSFetchedResultsController<BudgetCategory>!
    
    
    init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
        super.init(nibName: nil, bundle: nil)
        
        let request = BudgetCategory.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        fetchResult = NSFetchedResultsController(fetchRequest: request, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchResult.delegate = self
        
        do {
            try fetchResult.performFetch()
        }catch {
            print(error.localizedDescription)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - View Controller Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        tableView.register(BudgetDetailCell.self, forCellReuseIdentifier: "buds")
        // Do any additional setup after loading the view.
    }

    //MARK: - User Defined Functions

    func setupUI() {
        let addCategory = UIBarButtonItem(title: "Add Category", style: .plain, target: self, action: #selector(didPressAddBudget))
        navigationItem.rightBarButtonItem = addCategory
        navigationItem.rightBarButtonItem?.tintColor = .green
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Budget"
        
    }
    
    func deleteCategory(_ budgetCategory: BudgetCategory) {
        persistentContainer.viewContext.delete(budgetCategory)
        
        do {
            try persistentContainer.viewContext.save()
        }catch {
            showErrorMessage(title: "Whoops😮‍💨😮‍💨", message: "Failed to delete Category😞")
        }
    }
    
    @objc func didPressAddBudget(_ sender: UIBarButtonItem) {
        let nvc = UINavigationController(rootViewController: AddBudgetViewController(container: persistentContainer))
        present(nvc, animated: true)
    }
    
    //MARK: - Table View Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (fetchResult.fetchedObjects ?? []).count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "buds", for: indexPath) as! BudgetDetailCell
        cell.accessoryType = .disclosureIndicator
//        let bc = fetchResult.object(at: indexPath)
//        var config = cell.defaultContentConfiguration()
//        config.text = bc.name
//        cell.contentConfiguration = config
        
        let budgetCat = fetchResult.object(at: indexPath)
        cell.configure(budgetCat)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let bc = fetchResult.object(at: indexPath)
        navigationController?.pushViewController(BudgetDetailViewController(budgetCategory: bc, persistentContainer: persistentContainer), animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let budCat = fetchResult.object(at: indexPath)
            deleteCategory(budCat)
        }
    }
}

//MARK: - Extension for Core Data
extension ViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }
}
