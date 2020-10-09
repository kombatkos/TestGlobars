//
//  Alert.swift
//  TestGlobars
//
//  Created by Konstantin Porokhov on 10.10.2020.
//

import UIKit

class Alert {
    
    weak var delegate: URLStringDelegate?
    
    // Alert Controller
    func showAlert(title: String, message: String, completion: @escaping (_ alertController: UIAlertController) -> ()) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(alertAction)
        completion(alertController)
        
    }
}
