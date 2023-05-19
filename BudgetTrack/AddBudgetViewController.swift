//
//  AddBudgetViewController.swift
//  BudgetTrack
//
//  Created by Harsh Verma on 19/05/23.
//

import UIKit
import CoreData
class AddBudgetViewController: UIViewController {

    private var container: NSPersistentContainer
    
    init(container: NSPersistentContainer) {
        self.container = container
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    lazy var nametextField: UITextField = {
       let tf = UITextField()
        tf.placeholder = "Budget Name"
        tf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        tf.leftViewMode = .always
        tf.borderStyle = .roundedRect
        return tf
    }()
    
    lazy var ampunttextField: UITextField = {
       let tf = UITextField()
        tf.placeholder = "Amount"
        tf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        tf.leftViewMode = .always
        tf.borderStyle = .roundedRect
        return tf
    }()
    
    
    lazy var addBudgetButton: UIButton = {
        var config = UIButton.Configuration.bordered()
        let bt = UIButton(configuration: config)
        bt.translatesAutoresizingMaskIntoConstraints = false
        bt.setTitle("Save", for: .normal)
        return bt
    }()
    
    lazy var error: UILabel = {
       let lb = UILabel()
        lb.textColor = UIColor.red
        lb.text = ""
        lb.numberOfLines = 0
        return lb
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Add Budget"
        setupUI()
        
    }
    
    private func setupUI() {
        let stackView = UIStackView()
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = UIStackView.spacingUseSystem
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
        
        view.addSubview(stackView)
        
        stackView.addArrangedSubview(nametextField)
        stackView.addArrangedSubview(ampunttextField)
        stackView.addArrangedSubview(addBudgetButton)
        stackView.addArrangedSubview(error)
        
        nametextField.widthAnchor.constraint(equalToConstant: 300).isActive = true
        ampunttextField.widthAnchor.constraint(equalToConstant: 300).isActive = true
        addBudgetButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        addBudgetButton.addTarget(self, action: #selector(budgetButton), for: .touchUpInside)
        
        stackView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            
    }
    
    
    @objc func budgetButton(_ sender: UIButton) {
        if validateDataEntry {
            saveData()
        }else {
            error.text = "Whoops Missing fields"
        }
    }

    private var validateDataEntry: Bool {
        guard let name = nametextField.text, let amt = ampunttextField.text else {
            return false
        }
        return !name.isEmpty && !amt.isEmpty && amt.isNumeric && amt.isGreaterThan(0)
    }
    
    private func saveData() {
        guard let name = nametextField.text, let amt = ampunttextField.text else {
            return
        }
        do {
            let budgetCat = BudgetCategory(context: container.viewContext)
            budgetCat.name = name
            budgetCat.amount = Double(amt) ?? 0.0
           try container.viewContext.save()
            dismiss(animated: true)
        }catch {
            print("Error Dumping data!!!")
        }
        
    }

    
}
