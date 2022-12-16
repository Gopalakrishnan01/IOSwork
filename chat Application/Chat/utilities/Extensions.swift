//
//  Extensions.swift
//  Chat
//
//  Created by zs-mac-6 on 08/12/22.
//

import Foundation
import UIKit

private extension UIViewController{
    
    func hideKeyboardWhenTappedAround(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
    func showAlertMessage(with title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ok", style: .default))
        present(alert,animated: true,completion: nil)
        
    }
}

