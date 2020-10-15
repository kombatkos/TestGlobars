//
//  AuthorizationViewController.swift
//  TestGlobars
//
//  Created by Konstantin Porokhov on 05.10.2020.
//

import UIKit

protocol URLStringDelegate: class {
    var urlString: String { get }
}

class AuthorizationViewController: UIViewController, URLStringDelegate {
    
    //MARK: -  Properties
    
    private let networking = Networking()
    private let alert = Alert()
    
    private var globars: Globars? {
        // Observer
        willSet {
            guard let globars = newValue else { return }
                DispatchQueue.main.async {
                    self.indicator.isHidden = true
                    self.indicator.stopAnimating()
                    if globars.success == false {
                        // Show Alert
                        self.alert.showAlert(title: "Ошибка",
                                        message: self.globars?.data ?? "Попробуй снова", completion: { alertController in
                                            self.present(alertController, animated: true, completion: nil)
                                        })
                    } else {
                        // Show Map
                        self.pushMapViewController()
                    }
                }
        }
    }
    
    internal var urlString = "https://test.globars.ru/api/auth/login"
    private var isVertical = true
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    @IBOutlet weak var buttonEnter: UIButton!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        networking.delegate = self
        alert.delegate = self
        nameTextField.delegate = self
        passTextField.delegate = self
        getOrientation()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        getOrientation()
        setupSubviews()
    }
    
    func settingSubviews() {
    }
    
    //MARK: - IBActions
    
    @IBAction func enterPresed(_ sender: UIButton) {
        parsingFromCars()
    }
    
    //MARK: - Navigation
    
    private func parsingFromCars() {
        networking.postMethod(urlString: urlString,
                                       userName: nameTextField.text ?? "",
                                       password: passTextField.text ?? "",
                                       completion: { (data) in
                                        do {
                                            let decoder = JSONDecoder()
                                            self.globars = try decoder.decode(Globars.self, from: data)
                                            print("Token: ", self.globars?.data ?? "no data")
                                        }
                                        catch {
                                            print(error)
                                        }
                                       })
        indicator.isHidden = false
        indicator.startAnimating()
    }
    
    //MARK: - Helpers Methods
    
    // Setup Subviews
    private func getOrientation() {
        let width = view.bounds.width
        let height = view.bounds.height
        if height > width {
            isVertical = true
        } else {
            isVertical = false
        }
    }
    
    private func setupSubviews() {
        buttonEnter.layer.cornerRadius = 5
        indicator.isHidden = true
        if isVertical {
            stackView.axis = .vertical
        } else {
            stackView.axis = .horizontal
        }
    }
    //MARK: - Navigation
    
    private func pushMapViewController() {
        guard let vc = UIStoryboard(name:"Main", bundle:nil).instantiateViewController(withIdentifier: "MapVC") as? MapViewController else {
            print("Could not instantiate view controller with identifier of type ContainerViewController")
            return
        }
        guard let token = globars?.data else { return }
        vc.token = token
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
}
    //MARK: - UITextFieldDelegate
extension AuthorizationViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == nameTextField {
            textField.resignFirstResponder()
            passTextField.becomeFirstResponder()
        } else if textField == passTextField {
            parsingFromCars()
        }
        return true
    }
   
}
