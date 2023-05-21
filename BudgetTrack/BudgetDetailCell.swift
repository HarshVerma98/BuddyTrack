//
//  BudgetDetailCell.swift
//  BudgetTrack
//
//  Created by Harsh Verma on 21/05/23.
//

import UIKit
import SwiftUI

class BudgetDetailCell: UITableViewCell {
    
    // MARK: - UI Component Constructors
    
    lazy var nameLabel: UILabel = {
       let lbl = UILabel()
        return lbl
    }()
    
    lazy var amountLabel: UILabel = {
       let lbl = UILabel()
        return lbl
    }()
    
    lazy var remainingLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 14)
        lbl.alpha = 0.5
        return lbl
        
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupUI() {
        let stackView = UIStackView()
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 44)
        stackView.spacing = UIStackView.spacingUseSystem
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.addArrangedSubview(nameLabel)
        
        
        let vertStack = UIStackView()
        vertStack.alignment = .trailing
        vertStack.axis = .vertical
        vertStack.addArrangedSubview(amountLabel)
        vertStack.addArrangedSubview(remainingLabel)
        
        stackView.addArrangedSubview(vertStack)
        
        self.addSubview(stackView)
        
        stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        stackView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
    }
    
    func configure(_ budget: BudgetCategory) {
        nameLabel.text = budget.name
        amountLabel.text = budget.amount.formatAsCurrency()
        remainingLabel.text = "Remaining 50"
    }
}

// MARK: - Structs
struct BudgetDetailCellRepresent: UIViewRepresentable {
    func makeUIView(context: Context) -> some UIView {
        BudgetDetailCell(style: .default, reuseIdentifier: "detailCell")
        
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}

struct BudgetCellPreview: PreviewProvider {
    static var previews: some View {
        BudgetDetailCellRepresent()
    }
}
