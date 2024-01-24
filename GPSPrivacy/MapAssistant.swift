//
//  MapAssistant.swift
//  GPSPrivacy
//
//  Created by Jae hyung Kim on 1/24/24.
//

import UIKit
import MapKit


enum MapAssistant {
    // 위도 : 37.6544068000001, 경도 : 127.04561145393475
    static let defaultRegion = [37.65502, 127.05008]
    
    static let startResion = [37.4824761978647, 126.9521680487202]
    

        static func setRegion(mapView : MKMapView, latitude: Double, longitude: Double){
            
            let cl2d = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            
            let region = MKCoordinateRegion(center: cl2d, latitudinalMeters: 20000, longitudinalMeters: 20000)
            
            mapView.setRegion(region, animated: true)
            
            let anotation = MKPointAnnotation()
            anotation.coordinate = cl2d
            mapView.addAnnotation(anotation)
        }
    
    static func focusRegion(mapView : MKMapView, latitude: Double, longitude: Double){
        
        let cl2d = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        let region = MKCoordinateRegion(center: cl2d, latitudinalMeters: 400, longitudinalMeters: 400)
        
        mapView.setRegion(region, animated: true)
        
        let anotation = MKPointAnnotation()
        anotation.coordinate = cl2d
        mapView.addAnnotation(anotation)
    }
    
    static func setAnnotation(mapView: MKMapView, latitude : Double, longitude : Double) {
        let l2d = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = l2d
        
        mapView.addAnnotation(annotation)
        
    }
    
}
