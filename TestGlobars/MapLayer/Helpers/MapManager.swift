//
//  MapManager.swift
//  TestGlobars
//
//  Created by Konstantin Porokhov on 15.10.2020.
//

import Foundation
import GoogleMaps

protocol MapViewControllerDelegate {
    var mapView: GMSMapView! { get set }
    var markers: [GMSMarker] { get set }
}

class MapManager {
    
    //MARK: - Properties
    
    var delegate: MapViewControllerDelegate!
    
    func getPlaceCar(carsData: ListCars?, index: Int?) {
        
        guard let cars = carsData?.data else { return }
        
        for car in cars {
            if car.checked {
                let latitude = car.position.lt
                let longitude = car.position.ln
                let name = car.name
                
                // Creates a marker in the center of the map.
                var marker = GMSMarker()
                marker = GMSMarker(position: CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
                marker.map = delegate.mapView
                marker.title = name
                //        marker.snippet = "qweqwewe"
                marker.icon = UIImage(named: name)
                if !car.eye {
                    marker.opacity = 0.5
                }
                delegate.markers.append(marker)
            }
        }
        
        let selectCar = cars[index ?? 0]
        
        delegate.markers[index ?? 0].map = delegate.mapView
        if !selectCar.eye {
            delegate.markers[index ?? 0].opacity = 0.5
        }
        delegate.markers[index ?? 0].snippet = selectCar.name
        delegate.mapView.selectedMarker =  delegate.markers[index ?? 0]
        carIsHighlighter(carsData: carsData, index: index ?? 0)
    }
    
    func carIsHighlighter(carsData: ListCars?, index: Int?) {
        guard let index = index else { return }
        
        guard let cars = carsData?.data else { return }
        print("Камера на выбранный обЪект по индексу \(index)")
        
        let northEast = CLLocationCoordinate2D(latitude: cars[index].position.lt, longitude: cars[index].position.ln)
        let southWest = CLLocationCoordinate2D(latitude: cars[index].position.lt, longitude: cars[index].position.ln)
        let bounds = GMSCoordinateBounds(coordinate: northEast, coordinate: southWest)
        
        let update = GMSCameraUpdate.fit(bounds, withPadding: 50.0)
        delegate.mapView.setMinZoom(10, maxZoom: 15)
        delegate.mapView.moveCamera(update)
        
    }
}
