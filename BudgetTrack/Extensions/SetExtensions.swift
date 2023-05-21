//
//  SetExtensions.swift
//  BudgetTrack
//
//  Created by Harsh Verma on 21/05/23.
//

import Foundation

extension NSSet {
    func toArray<T>() -> [T] {
        let array = self.map{ $0 as! T}
        return array
    }
}
