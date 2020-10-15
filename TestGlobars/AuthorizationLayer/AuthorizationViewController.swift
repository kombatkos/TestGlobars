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

protocol AuthorizationViewControllerDelegate: class {
    func showMap()
}

class AuthorizationViewController: UIViewController, URLStringDelegate {
    
    //MARK: -  Properties
    let networking = Networking()
    let alert = Alert()
    
    var globars: Globars? {
        willSet {
            guard let globars = newValue else { return }
                DispatchQueue.main.async {
                    self.indicator.isHidden = true
                    self.indicator.stopAnimating()
                    if globars.success == false {
                        self.alert.showAlert(title: "Ошибка",
                                        message: self.globars?.data ?? "try again!", completion: { alertController in
                                            self.present(alertController, animated: true, completion: nil)
                                        })
                    } else {
                        print("Show map")
//                        self.performSegue(withIdentifier: "Map", sender: nil)
                        self.pushContainerViewController()
                        
                    }
                }
        }
    }
    
    var urlString = "https://test.globars.ru/api/auth/login"
    var isVertical = true
    
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
        getOrientation()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        getOrientation()
        setupSubviews()
    }
    
//MARK: - IBActions
    @IBAction func enterPresed(_ sender: UIButton) {
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
//        postMethod(url: url, userName: nameTextField.text!,
//                   password: passTextField.text!)
        indicator.isHidden = false
        indicator.startAnimating()
    }
    
    //MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Map" {
           let mapController = segue.destination as! MapViewController
            guard let token = globars?.data else { return }
            mapController.token = token
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
    
    func setupSubviews() {
        buttonEnter.layer.cornerRadius = 5
        indicator.isHidden = true
        if isVertical {
            stackView.axis = .vertical
        } else {
            stackView.axis = .horizontal
        }
    }
    
    func pushContainerViewController() {
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

