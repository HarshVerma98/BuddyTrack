//
//  ViewController.swift
//  BudgetTrack
//
//  Created by Harsh Verma on 13/05/23.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    private var persistentContainer: NSPersistentContainer
    
    init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
       
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
}

