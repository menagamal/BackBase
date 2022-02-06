//
//  CountryTableViewCell.swift
//  BackBaseTask
//
//  Created by Mena Gamal on 07/02/2022.
//

import UIKit

class CountryTableViewCell: UITableViewCell {

    @IBOutlet private weak var labelTitle: UILabel!
    @IBOutlet private weak var labelSubTitle: UILabel!
    
    func configure( title: String, subTitle: String) {
        self.labelTitle.text = title
        self.labelSubTitle.text = subTitle
    }
}
