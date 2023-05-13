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
        view.backgroundColor = .brown
        
        // Do any additional setup after loading the view.
    }


}

