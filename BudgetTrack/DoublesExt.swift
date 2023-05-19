//
//  DoublesExt.swift
//  BudgetTrack
//
//  Created by Harsh Verma on 19/05/23.
//

import Foundation
extension Double {
    
    func formatAsCurrency() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter.string(from: NSNumber(value: self)) ?? "0.00"
    }
}
