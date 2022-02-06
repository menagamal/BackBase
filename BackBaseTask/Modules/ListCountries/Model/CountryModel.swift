//
//  CountryModel.swift
//  BackBaseTask
//
//  Created by Mena Gamal on 07/02/2022.
//

import Foundation
struct CountryModel: Codable {
    let country, name: String
    let id: Int
    let coord: Coord

    enum CodingKeys: String, CodingKey {
        case country, name
        case id = "_id"
        case coord
    }
}
