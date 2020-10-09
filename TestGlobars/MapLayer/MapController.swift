//
//  MapController.swift
//  TestGlobars
//
//  Created by Konstantin Porokhov on 06.10.2020.
//

import UIKit
import MapKit

class MapController: UIViewController, URLStringDelegate {
    
    let networking = Networking()
    
    let urlString =  "https://test.globars.ru/api/tracking/sessions/"
    
    var token: String?
    var userData: UserData?
    var cars: ListCars?
    var id: String? {
        willSet {
            guard let id = newValue else { return print("id is nil")}
            print(id)
            
                networking.getMethod(urlString: "https://test.globars.ru/api/tracking/\(id)/units",
                      token: self.token,
                      completion: { data in
                        do {
                            let decoder = JSONDecoder()
                            self.cars = try decoder.decode(ListCars.self, from: data)
                        }
                        catch {
                            print{error}
                        }
                      })
        }
    }
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        networking.delegate = self
       
        getID()
    }
    
    @IBAction func plusAction(_ sender: UIButton) {
        let region = MKCoordinateRegion(center: self.mapView.region.center, span: MKCoordinateSpan(latitudeDelta: mapView.region.span.latitudeDelta * 0.7, longitudeDelta: mapView.region.span.longitudeDelta * 0.7))
        mapView.setRegion(region, animated: false)
    }
    
    @IBAction func minusAction(_ sender: UIButton) {
        let region = MKCoordinateRegion(center: self.mapView.region.center, span: MKCoordinateSpan(latitudeDelta: mapView.region.span.latitudeDelta / 0.7, longitudeDelta: mapView.region.span.longitudeDelta / 0.7))
        mapView.setRegion(region, animated: false)
    }
    
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
}
