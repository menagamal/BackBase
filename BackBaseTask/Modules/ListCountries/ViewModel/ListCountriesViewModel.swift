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
    var allCountries: MultipleBinding<[CountryModel]>? = MultipleBinding([CountryModel]())
    
    func fetchCountries() {
        if let path = Bundle.main.path(forResource: "cities", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let sortedCountries = try JSONDecoder().decode([CountryModel].self, from: data).sorted(by:  {
                    $0.name < $1.name
                })
                self.countries?.value = sortedCountries
                self.allCountries?.value = sortedCountries
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
    
    func search(str: String) {
        if str.isEmpty {
            if let value = self.allCountries?.value {
                self.countries?.value = value
            }
            return
        }
        let rangedValues = BINARY_SEARCH_COUNTRIES(str: str)
        countries?.value = SEARCH_SUB_ARRAY(str: str, rangedArray: rangedValues)
    }
}

private extension ListCountriesViewModel {
    
    func BINARY_SEARCH_COUNTRIES(str: String) -> [CountryModel] {
        guard let allCountries = allCountries?.value else {
             return []
        }
        var lowerIndex = 0
        var upperIndex = allCountries.count - 1
        let searchKey = str.first!
        var didFoundTheRange = false
        var result = [CountryModel]()
        while (lowerIndex < upperIndex && !didFoundTheRange) {
            let lowerIndexChar = allCountries[lowerIndex].name.first!
            let upperIndexChar = allCountries[upperIndex].name.first!
            if lowerIndexChar < searchKey {
                lowerIndex += 1
            }
            if upperIndexChar > searchKey {
                upperIndex -= 1
            }
            
            if upperIndexChar == searchKey && lowerIndexChar == searchKey {
                didFoundTheRange = true
            }
        }
        result = Array(allCountries[lowerIndex...upperIndex])
        return result
    }
    
    func SEARCH_SUB_ARRAY(str: String, rangedArray: [CountryModel]) -> [CountryModel] {
        var results = [CountryModel]()
        for country in rangedArray {
            if country.name.contains(str) {
                results.append(country)
            }
        }
        return results
    }
}
