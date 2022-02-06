//
//  ListCountriesViewController.swift
//  BackBaseTask
//
//  Created by Mena Gamal on 07/02/2022.
//

import UIKit

class ListCountriesViewController: UIViewController {

    var viewModel: ListCountriesViewModel?
    
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var listTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        setupTableView()
    }
    
    private func setupTableView() {
        listTableView.register(UINib(nibName: "CountryTableViewCell", bundle: nil), forCellReuseIdentifier: "CountryTableViewCell")
        listTableView.delegate = self
        listTableView.dataSource = self
    }
}

extension ListCountriesViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {}
}

extension ListCountriesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CountryTableViewCell") as? CountryTableViewCell  else {
            return UITableViewCell()
        }
        cell.configure(title: "TEST", subTitle: "SUB TITLE TEST")
        return cell
    }
    
}
