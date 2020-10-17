//
//  MapViewController.swift
//  TestGlobars
//
//  Created by Konstantin Porokhov on 10.10.2020.
//

import UIKit
import GoogleMaps

class MapViewController: UIViewController, GMSMapViewDelegate, MapViewControllerDelegate {
    
    //MARK: - Properties
    
    private let networking = Networking()
    private let mapManager = MapManager()
    private var menuViewController: MenuViewController!
    
    private let urlString =  "https://test.globars.ru/api/tracking/sessions/"
    var token: String?
    var userData: UserData?
    var carsData: ListCars?
    private var id: String? {
        willSet {
            guard let id = newValue else { return print("id is nil")}
            print(id)
            
            networking.getMethod(urlString: "https://test.globars.ru/api/tracking/\(id)/units",
                                 token: self.token,
                                 completion: { data in
                                    do {
                                        let decoder = JSONDecoder()
                                        self.carsData = try decoder.decode(ListCars.self, from: data)
                                    }
                                    catch {
                                        print{error}
                                    }
                                 })
        }
    }
    
    private var index: Int?
    var markers = [GMSMarker]()
    
    //MARK: - IB Outlets
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var navigationBar: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        mapManager.delegate = self
        getID()
        
        mapView.addSubview(minusButton)
        mapView.addSubview(plusButton)
        menuViewController = self.storyboard?.instantiateViewController(identifier: "MenuVC") as? MenuViewController
        menuViewController.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mapManager.getPlaceCar(carsData: carsData, index: index)
    }
    
    //MARK: - IBActions
    
    @IBAction func plusButtonAction(_ sender: UIButton) {
        let cameraUpdate = GMSCameraUpdate.zoomIn()
        mapView.moveCamera(cameraUpdate)
        
    }
    
    @IBAction func minusButtonAction(_ sender: UIButton) {
        let cameraUpdate = GMSCameraUpdate.zoomOut()
        mapView.moveCamera(cameraUpdate)
    }
    @IBAction func exitAction(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func menuAction(_ sender: UIButton) {
        if AppDelegate.menuIsMove {
            showMenu(carsData: carsData)
        } else {
            hideMenu(index: nil)
        }
    }
    
    //MARK: - Networking
    
    // get ID
    private func getID() {
        networking.getMethod(urlString: urlString, token: token, completion: { data in
            do {
                let decoder = JSONDecoder()
                self.userData = try decoder.decode(UserData.self, from: data)
                guard let id = self.userData?.data.first?.id else { return }
                print("id user this: ", id)
                self.id = id
            }
            catch {
                print(error)
            }
        })
    }
    
}

//MARK: - MenuViewControllerDelegate

extension MapViewController: MenuViewControllerDelegate {
    
    func showMenu(carsData: ListCars?) {
        let indent = UIScreen.main.bounds.height - mapView.bounds.height
        
        UIView.animate(withDuration: 0.3) {
            self.menuViewController.view.frame = CGRect(x: 0, y: indent, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
            
            self.menuViewController.carsData = carsData
            self.addChild(self.menuViewController)
            self.view.addSubview(self.menuViewController.view)
            AppDelegate.menuIsMove = false
        }
    }
    
    func hideMenu(index: Int?) {
        self.index = index
        let indent = UIScreen.main.bounds.height - mapView.bounds.height
        
        UIView.animate(withDuration: 0.3) {
            self.menuViewController.view.frame = CGRect(x: -UIScreen.main.bounds.size.width, y: indent, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
            self.index = index
        } completion: { (finished) in
            self.menuViewController.view.removeFromSuperview()
            AppDelegate.menuIsMove = true
        }
        
        if index != nil {
//            mapView.clear()
//            getPlaceCar()
            mapView.selectedMarker = markers[index!]
            mapManager.carIsHighlighter(carsData: carsData, index: index)
        }
    }
}
