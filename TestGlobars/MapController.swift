//
//  MapController.swift
//  TestGlobars
//
//  Created by Konstantin Porokhov on 06.10.2020.
//

import UIKit
import MapKit

class MapController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func plusAction(_ sender: UIButton) {
        let region = MKCoordinateRegion(center: self.mapView.region.center, span: MKCoordinateSpan(latitudeDelta: mapView.region.span.latitudeDelta*0.7, longitudeDelta: mapView.region.span.longitudeDelta*0.7))
        mapView.setRegion(region, animated: false)
    }
    @IBAction func minusAction(_ sender: UIButton) {
        let region = MKCoordinateRegion(center: self.mapView.region.center, span: MKCoordinateSpan(latitudeDelta: mapView.region.span.latitudeDelta / 0.7, longitudeDelta: mapView.region.span.longitudeDelta / 0.7))
        mapView.setRegion(region, animated: false)
    }
    
}
