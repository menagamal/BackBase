//
//  ListCountriesViewModel.swift
//  BackBaseTask
//
//  Created by Mena Gamal on 07/02/2022.
//

import Foundation
import MapKit

class ListCountriesViewModel {
    
    var countries: MultipleBinding<[CountryModel]>? = MultipleBinding([CountryModel]())
    
    func fetchCountries() {
        if let path = Bundle.main.path(forResource: "cities", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let temp = try JSONDecoder().decode([CountryModel].self, from: data)
                self.countries?.value = temp
            } catch {
                // handle error
            }
        }
    }
    
    func didSelectCountryWithIndex(index: Int) {
        if let model = countries?.value[index] {
            let latitude: CLLocationDegrees = model.coord.lat
            let longitude: CLLocationDegrees = model.coord.lon
            let regionDistance:CLLocationDistance = 10000
            let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
            let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
            let options = [
                MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
                MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
            ]
            let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
            let mapItem = MKMapItem(placemark: placemark)
            mapItem.name = model.name
            mapItem.openInMaps(launchOptions: options)
        }
    }
}
