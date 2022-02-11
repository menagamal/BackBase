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
            let router = ListRouterImp(rootViewController: conrtoller)
            let viewModel = ListCountriesViewModelImp(router: router)
            conrtoller.viewModel = viewModel
            return conrtoller
        }
        return nil
    }
}
