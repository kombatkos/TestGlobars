//
//  MapController.swift
//  TestGlobars
//
//  Created by Konstantin Porokhov on 06.10.2020.
//

import UIKit
import MapKit

class MapController: UIViewController {
    
    let url = URL(string: "https://go.globars.ru/api/tracking/sessions/")
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData(url: url)
    }
    
    @IBAction func plusAction(_ sender: UIButton) {
        let region = MKCoordinateRegion(center: self.mapView.region.center, span: MKCoordinateSpan(latitudeDelta: mapView.region.span.latitudeDelta*0.7, longitudeDelta: mapView.region.span.longitudeDelta*0.7))
        mapView.setRegion(region, animated: false)
    }
    
    @IBAction func minusAction(_ sender: UIButton) {
        let region = MKCoordinateRegion(center: self.mapView.region.center, span: MKCoordinateSpan(latitudeDelta: mapView.region.span.latitudeDelta / 0.7, longitudeDelta: mapView.region.span.longitudeDelta / 0.7))
        mapView.setRegion(region, animated: false)
    }
    
    func fetchData(url: URL?) {
        guard let url = url else { return }
//        let session = URLSession.shared
        
        var request  = URLRequest(url: url)
        let sessionConfiguration = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfiguration)
        request.httpMethod = "GET"
        request.addValue("Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjU5OWZkNTRhZGUxNjkzNGIxMDI2NzkyNSIsIm5hbWUiOiJyb290IiwiYWNjb3VudElkIjoiNTk5ZmQ3OWNlZGFiOTdmZjMwNWFjOGQ4IiwiaXNEaWxsZXIiOnRydWUsImlhdCI6MTU2ODAwNjg5NywiZXhwIjoxNTY4ODcwODk3fQ.0qVZhmHdfXQa-u5t1PV_W-v_Artkdg2QzQTTZiViTpc", forHTTPHeaderField: "Authorization")
        
        session.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print(response)
            }
            guard let data = data else { return }
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print(json)
            }
            catch {
                print(error)
            }
        }.resume()
    }
    
}
