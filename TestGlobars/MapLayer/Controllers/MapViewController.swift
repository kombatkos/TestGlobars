//
//  MapViewController.swift
//  TestGlobars
//
//  Created by Konstantin Porokhov on 10.10.2020.
//

import UIKit
import GoogleMaps

class MapViewController: UIViewController, GMSMapViewDelegate {
    
    //MARK: - Properties
    let networking = Networking()
    var menuViewController: MenuViewController!
    
    let urlString =  "https://test.globars.ru/api/tracking/sessions/"
    var token: String?
    var userData: UserData?
    var carsData: ListCars?
    var id: String? {
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
    
    var index: Int?
    var markers = [GMSMarker]()
    
    //MARK: - IB Outlets & Actions
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var navigationBar: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        getID()
        
        mapView.addSubview(minusButton)
        mapView.addSubview(plusButton)
        menuViewController = self.storyboard?.instantiateViewController(identifier: "MenuVC") as? MenuViewController
        menuViewController.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getPlaceCar()
    }
    
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
    
    //MARK:- Helpers Methods
    
    // get ID
    func getID() {
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
    
    func getPlaceCar() {
        
        guard let cars = carsData?.data else { return }
//        var markers = [GMSMarker]()
        for car in cars {
            if car.checked {
                let latitude = car.position.lt
                let longitude = car.position.ln
                let name = car.name

                // Creates a marker in the center of the map.
                var marker = GMSMarker()
                marker = GMSMarker(position: CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
                marker.map = mapView
                marker.title = name
                //        marker.snippet = "qweqwewe"
                marker.icon = UIImage(named: name)
                if !car.eye {
                    marker.opacity = 0.5
                }
                self.markers.append(marker)
            }
        }
        let selectCar = cars[index ?? 0]
        
        markers[index ?? 0].map = mapView
        if !selectCar.eye {
            markers[index ?? 0].opacity = 0.5
        }
        markers[index ?? 0].snippet = selectCar.name
        mapView.selectedMarker =  markers[index ?? 0]
        carIsHighlighter(index: index ?? 0)
    }

}

extension MapViewController {
    
    func carIsHighlighter(index: Int?) {
        guard let index = index else { return }
        
        guard let cars = carsData?.data else { return }
        print("Камера на выбранный обЪект по индексу \(index)")
        
        let northEast = CLLocationCoordinate2D(latitude: cars[index].position.lt, longitude: cars[index].position.ln)
        let southWest = CLLocationCoordinate2D(latitude: cars[index].position.lt, longitude: cars[index].position.ln)
        let bounds = GMSCoordinateBounds(coordinate: northEast, coordinate: southWest)

        let update = GMSCameraUpdate.fit(bounds, withPadding: 50.0)
        mapView.setMinZoom(10, maxZoom: 15)
        mapView.moveCamera(update)
        
    }
    
}

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
            carIsHighlighter(index: index)
        }
    }
}
