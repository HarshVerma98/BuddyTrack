//
//  AlertExtension.swift
//  BudgetTrack
//
//  Created by Harsh Verma on 21/05/23.
//

import UIKit

extension ViewController {
    func showErrorMessage(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
    }
}
