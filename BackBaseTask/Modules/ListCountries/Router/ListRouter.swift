//
//  ListRouter.swift
//  BackBaseTask
//
//  Created by Mena Gamal on 11/02/2022.
//

import Foundation
import MapKit
import UIKit


protocol ListRouter: AnyObject {
    var rootViewController: UIViewController? { get set }
    func present(to destination: ListRouterImp.Destination)
    func navigate(to destination: ListRouterImp.Destination)
}

class ListRouterImp: ListRouter {
  
    enum Destination {
        case openMap(latitude: CLLocationDegrees, longitude: CLLocationDegrees, name: String)
    }
    
    internal weak var rootViewController: UIViewController?
    
    init(rootViewController: UIViewController) {
        self.rootViewController = rootViewController
    }
    
    func navigate(to destination: ListRouterImp.Destination) {
        if let viewController = makeViewController(for: destination) {
            rootViewController?.show(viewController, sender: rootViewController)
        }
    }
    
    func present(to destination: ListRouterImp.Destination) {
        if let viewController = makeViewController(for: destination) {
            rootViewController?.present(viewController, animated: true)
        }
    }
}
private extension ListRouterImp {
    
    func makeViewController(for destination: Destination) -> UIViewController? {
        switch destination {
        case .openMap(let lat, let lon, let name):
            openInMaps(latitude: lat, longitude: lon, name: name)
            return nil
        }
    }
    
    func openInMaps(latitude: CLLocationDegrees, longitude: CLLocationDegrees, name: String) {
        let regionDistance:CLLocationDistance = 10000
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = name
        mapItem.openInMaps(launchOptions: options)
    }
}


