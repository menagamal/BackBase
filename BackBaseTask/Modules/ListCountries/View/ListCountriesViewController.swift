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
        viewModel?.countries?.bindAndFire(self, { [weak self] _ in
            self?.listTableView.reloadData()
        })
        viewModel?.genericError?.bindAndFire(self, { [weak self] message in
            self?.showErrorMessage(message: message)
        })
        viewModel?.fetchCountries()
    }
    
    private func setupTableView() {
        listTableView.register(UINib(nibName: "CountryTableViewCell", bundle: nil), forCellReuseIdentifier: "CountryTableViewCell")
        listTableView.delegate = self
        listTableView.dataSource = self
    }

    private func showErrorMessage(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    deinit {
        viewModel?.countries?.unbind(self)
    }
}

extension ListCountriesViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel?.search(str: searchText)
    }
}

extension ListCountriesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.countries?.value.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CountryTableViewCell") as? CountryTableViewCell  else {
            return UITableViewCell()
        }
        let title = "\(viewModel?.countries?.value[indexPath.row].name ?? ""), \(viewModel?.countries?.value[indexPath.row].country ?? "")"
        let subTitle = "\(viewModel?.countries?.value[indexPath.row].coord.lat ?? 0.0), \(viewModel?.countries?.value[indexPath.row].coord.lon ?? 0.0)"
        cell.configure(title: title, subTitle: subTitle)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel?.didSelectCountryWithIndex(index: indexPath.row)
    }
}

