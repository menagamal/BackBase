//
//  ListCountriesViewModel.swift
//  BackBaseTask
//
//  Created by Mena Gamal on 07/02/2022.
//

import Foundation
import MapKit

protocol ListCountriesViewModel: AnyObject {
    var countries: MultipleBinding<[CountryModel]>? { get set }
    func didSelectCountryWithIndex(index: Int)
    func search(str: String)
    func fetchCountries()
}
class ListCountriesViewModelImp: ListCountriesViewModel {
    
    var countries: MultipleBinding<[CountryModel]>? = MultipleBinding([CountryModel]())
    
    private var allCountries: MultipleBinding<[CountryModel]>? = MultipleBinding([CountryModel]())
    
    private var savedFilters: [String.Element: [CountryModel]] = [:]
    
    private var router: ListRouter?

    init(router: ListRouter) {
        self.router = router
    }

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
                // handle errorx
            }
        }
    }
    
    func didSelectCountryWithIndex(index: Int) {
        if let model = countries?.value[index] {
            router?.present(to: .openMap(latitude: model.coord.lat, longitude: model.coord.lon, name: model.name))
        }
    }
    
    func search(str: String) {
        if str.isEmpty {
            if let value = self.allCountries?.value {
                self.countries?.value = value
            }
            return
        }
        let rangedValues = BINARY_SEARCH_COUNTRIES(str: str, allCountries: allCountries?.value ?? [])
        countries?.value = SEARCH_SUB_ARRAY(str: str, rangedArray: rangedValues)
    }
}

extension ListCountriesViewModelImp {
    
    func BINARY_SEARCH_COUNTRIES(str: String, allCountries: [CountryModel]) -> [CountryModel] {
        var lowerIndex = 0
        var upperIndex = allCountries.count - 1
        let searchKey = str.first!
        if let savedResult = savedFilters[searchKey] {
            return savedResult
        }
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
        savedFilters[searchKey] = result
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
