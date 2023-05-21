//
//  BudgetCategoryCDClass.swift
//  BudgetTrack
//
//  Created by Harsh Verma on 21/05/23.
//

import CoreData

@objc(BudgetCategory)
public class BudgetCategory: NSManagedObject {
    var totalTransaction: Double {
        let transact: [Transaction] = transactions?.toArray() ?? []
        return transact.reduce(0) { next, transaction in
            next + transaction.amount
        }
    }
    
    var remainingAmount: Double {
        amount - totalTransaction
    }
}
