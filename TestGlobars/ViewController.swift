//
//  ViewController.swift
//  TestGlobars
//
//  Created by Konstantin Porokhov on 05.10.2020.
//

import UIKit

class ViewController: UIViewController {
    
    var globars: Globars?
    let url = URL(string: "https://go.globars.ru/api/auth/login")
    var isVertical = true
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    @IBOutlet weak var buttonEnter: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonEnter.layer.cornerRadius = 5
        getOrientation()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        getOrientation()
        setupConstraint()
    }
    

    @IBAction func enterPresed(_ sender: UIButton) {
        postMethod(url: url, userName: nameTextField.text!,
                   password: passTextField.text!)
    }
    
    // Get Orientation
    func getOrientation() {
        let width = view.bounds.width
        let height = view.bounds.height
        if height > width {
            isVertical = true
        } else {
            isVertical = false
        }
    }
    
    func setupConstraint() {
        if isVertical {
            stackView.axis = .vertical
        } else {
            stackView.axis = .horizontal
        }
    }
    
    // POST Method
    func postMethod(url: URL?, userName: String, password: String) {
        guard let url = url else { return }
        let parameters = ["username": userName, "password": password]
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else { return }
        request.httpBody = httpBody
        
        let session = URLSession.shared
        session.dataTask(with: request) { [self] (data, response, error) in
            if let response = response {
                print(response)
            }
            guard let data = data else { return }
            
            do {
                let decoder = JSONDecoder()
                self.globars = try decoder.decode(Globars.self, from: data)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    if self.globars?.success == false {
                        self.showAlert(title: "Error",
                                       message: self.globars?.data ?? "try again!")
                    }
                }
                
            } catch {
                print(error)
            }
        }.resume()
    }
    
    // Alert Controller
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
    }
    
}

