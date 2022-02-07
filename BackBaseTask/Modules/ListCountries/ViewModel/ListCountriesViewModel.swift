//
//  ListCountriesViewModel.swift
//  BackBaseTask
//
//  Created by Mena Gamal on 07/02/2022.
//

import Foundation

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
    
}
