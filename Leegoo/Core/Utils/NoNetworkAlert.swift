//
//  NoNetworkAlert.swift
//  Leegoo
//
//  Created by TaqieAllah on 07/05/2026.
//

import Foundation

import UIKit

extension UIViewController {
    func showAlert(title: String, message: String, buttonTitle: String = "OK") {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: buttonTitle, style: .default))
            
            if self.presentedViewController == nil {
                self.present(alert, animated: true)
            }
        }
    }
    
    func showNoInternetAlert() {
        showAlert(
            title: "No Internet",
            message: "Please check your connection and try again."
        )
    }
    
    func observeNetworkChanges(using selector: Selector) {
            NotificationCenter.default.addObserver(
                self,
                selector: selector,
                name: .networkStatusDidChange,
                object: nil
            )
        }
        
        func stopObservingNetworkChanges() {
            NotificationCenter.default.removeObserver(
                self,
                name: .networkStatusDidChange,
                object: nil
            )
        }
    
}
