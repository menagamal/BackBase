//
//  BackBaseTaskTests.swift
//  BackBaseTaskTests
//
//  Created by Mena Gamal on 07/02/2022.
//

import XCTest
@testable import BackBaseTask

class BackBaseTaskTests: XCTestCase {

    var listViewModel: ListCountriesViewModelImp {
        return ListCountriesViewModelImp(router: router)
    }

    lazy var router = ListRouterMocks()

    func testJsonFile() {
        if let _ =  Bundle.main.path(forResource: "cities", ofType: "json") {
            listViewModel.fetchCountries()
            XCTAssertNotNil(listViewModel.countries)
        } else {
            XCTFail("JSON FILE NOT FOUND")
        }
    }

    func testBinarySearch() {
        let result = listViewModel.BINARY_SEARCH_COUNTRIES(str: "H", allCountries: constructTestData())
        XCTAssertEqual(result.count, 3)
        
        for item in result {
            if item.name.first != "H" {
                XCTFail("ERROR IN BINARY SEARCH")
            }
        }
    }
    
    private func constructTestData() -> [CountryModel] {
        var arr = [CountryModel]()
        let cities = ["Amsterdam", "Boston", "Chicago", "City", "Corona", "Gastonia", "Hampton", "Hello", "Hollywood", "Json", "Las Vegas"]
        for item in cities {
            arr.append(CountryModel(country: item, name: item, id: 0, coord: Coord(lon: 0, lat: 0)))
        }
        return arr
    }

}
