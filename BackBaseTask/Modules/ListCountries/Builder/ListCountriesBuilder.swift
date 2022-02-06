//
//  ListCountriesBuilder.swift
//  BackBaseTask
//
//  Created by Mena Gamal on 07/02/2022.
//

import Foundation
import UIKit

class ListCountriesBuilder {
    func instantiate() -> ListCountriesViewController? {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        if let conrtoller = storyboard.instantiateViewController(withIdentifier: "ListCountriesViewController") as? ListCountriesViewController {
            let viewModel = ListCountriesViewModel()
            conrtoller.viewModel = viewModel
            return conrtoller
        }
        return nil
    }
}
