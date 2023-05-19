//
//  ViewController.swift
//  BudgetTrack
//
//  Created by Harsh Verma on 13/05/23.
//

import UIKit
import CoreData

class ViewController: UITableViewController {

    private var persistentContainer: NSPersistentContainer
    private var fetchResult: NSFetchedResultsController<BudgetCategory>!
    
    
    init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
        super.init(nibName: nil, bundle: nil)
        
        var request = BudgetCategory.fetchRequest()
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "buds")
        // Do any additional setup after loading the view.
    }


    func setupUI() {
        let addCategory = UIBarButtonItem(title: "Add Category", style: .plain, target: self, action: #selector(didPressAddBudget))
        navigationItem.rightBarButtonItem = addCategory
        navigationItem.rightBarButtonItem?.tintColor = .green
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Budget"
        
    }
    
    @objc func didPressAddBudget(_ sender: UIBarButtonItem) {
        let nvc = UINavigationController(rootViewController: AddBudgetViewController(container: persistentContainer))
        present(nvc, animated: true)
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (fetchResult.fetchedObjects ?? []).count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "buds", for: indexPath)
        
        let bc = fetchResult.object(at: indexPath)
        var config = cell.defaultContentConfiguration()
        config.text = bc.name
        cell.contentConfiguration = config
        return cell
    }
}

extension ViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }
}
