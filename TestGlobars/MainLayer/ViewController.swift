//
//  ViewController.swift
//  TestGlobars
//
//  Created by Konstantin Porokhov on 05.10.2020.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: -  Properties
    var globars: Globars? {
        willSet {
            guard let globars = newValue else { return }
                DispatchQueue.main.async {
                    self.indicator.isHidden = true
                    self.indicator.stopAnimating()
                    if globars.success == false {
                        self.showAlert(title: "Ошибка",
                                       message: self.globars?.data ?? "try again!")
                    } else {
                        self.performSegue(withIdentifier: "Map", sender: nil)
                    }
                }
        }
    }
    let url = URL(string: "https://go.globars.ru/api/auth/login")
    var isVertical = true
    
    //MARK: - Outlets
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    @IBOutlet weak var buttonEnter: UIButton!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonEnter.layer.cornerRadius = 5
        getOrientation()
        indicator.isHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        getOrientation()
        setupConstraint()
    }
    

    @IBAction func enterPresed(_ sender: UIButton) {
        postMethod(url: url, userName: nameTextField.text!,
                   password: passTextField.text!)
        indicator.isHidden = false
        indicator.startAnimating()
    }
    
    //MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Map" {
            
        }
    }
    //MARK: - Helpers Methods
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
        let parameters = ["username": "raz", "password": "gabitus"]
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("ru", forHTTPHeaderField: "Accept-Language")
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
                print(self.globars?.data ?? "no data")
            }
            catch {
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

