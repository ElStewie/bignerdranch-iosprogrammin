//
//  MapViewController.swift
//  WorldTrotter
//
//  Created by Hisham Abraham on 2/14/17.
//  Copyright © 2017 Hisham Abraham. All rights reserved.
//

import UIKit
import MapKit
class MapViewController: UIViewController {
    
    var mapView: MKMapView!
    
    override func loadView() {
        mapView = MKMapView()
        view = mapView
        
        let standardString = NSLocalizedString(" Standard", comment: "Standard map view")
        let satelliteString = NSLocalizedString(" Satellite", comment: "Satellite map view")
        let hybridString = NSLocalizedString(" Hybrid", comment: "Hybrid map view")
        let segmentedControl = UISegmentedControl( items: [standardString, satelliteString, hybridString])
        

        segmentedControl.backgroundColor = UIColor.white.withAlphaComponent( 0.5)
        segmentedControl.selectedSegmentIndex = 0
        
        segmentedControl.addTarget( self, action: #selector( MapViewController.mapTypeChanged(_:)), for: .valueChanged)
        
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(segmentedControl)
        
        let topConstraint = segmentedControl.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 8)
        
        let margins = view.layoutMarginsGuide
        let leadingConstraint = segmentedControl.leadingAnchor.constraint(equalTo: margins.leadingAnchor)
        let trainingConstraint = segmentedControl.trailingAnchor.constraint(equalTo: margins.trailingAnchor)
        
        topConstraint.isActive=true
        leadingConstraint.isActive=true
        trainingConstraint.isActive=true
        
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        print(" MapViewController loaded its view.")
        
    }
    
    func mapTypeChanged(_ segControl: UISegmentedControl) {
        switch segControl.selectedSegmentIndex {
        case 0:
            mapView.mapType = .standard
        case 1:
            mapView.mapType = .hybrid
        case 2:
            mapView.mapType = .satellite
        default:
            break
        }
    }
    
}
