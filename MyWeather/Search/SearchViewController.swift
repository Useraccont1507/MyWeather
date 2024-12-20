//
//  SearchViewController.swift
//  MyWeather
//
//  Created by Illia Verezei on 18.11.2024.
//

import UIKit

class SearchCityViewController: UIViewController {
  
  weak var delegateFirstViewController: PushFromFisrtViewControllerDelegate?
  weak var delegateReloadCities: ReloadCitiesTableViewControllerDelegate?
  
  private var resultForTableView: [CityElement] = []
  
  lazy private var toolBar = UIToolbar()
  lazy private var searchBar = UISearchBar()
  lazy private var resultTableView = UITableView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    setupToolBar(toolBar)
    setupSearchBar(searchBar)
    setupTableView(resultTableView)
  }
  
  private func setupToolBar(_ bar: UIToolbar) {
    bar.barTintColor = .white
    bar.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(bar)
    
    NSLayoutConstraint.activate([
      bar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      bar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      bar.trailingAnchor.constraint(equalTo: view.trailingAnchor)
    ])
    
    toolBar.items = [
      UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action:  #selector(dissmissViewController)),
      UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
      UIBarButtonItem(customView: SearchTitleView()),
      UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    ]
  }
  
  private func setupSearchBar(_ bar: UISearchBar) {
    bar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
    bar.backgroundColor = .systemBackground
    bar.placeholder = "searchbar_placeholder".localized
    bar.delegate = self
    bar.keyboardType = .default
    bar.searchBarStyle = .prominent
    bar.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(bar)
    
    NSLayoutConstraint.activate([
      bar.topAnchor.constraint(equalTo: toolBar.bottomAnchor),
      bar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      bar.trailingAnchor.constraint(equalTo: view.trailingAnchor)
    ])
  }
  
  private func setupTableView(_ tableView: UITableView) {
    tableView.isScrollEnabled = false
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(ResultTableViewCell.self, forCellReuseIdentifier: "cell")
    tableView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(tableView)
    
    NSLayoutConstraint.activate([
      tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
      tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      tableView.heightAnchor.constraint(equalToConstant: 250)
    ])
  }
  
  @objc private func dissmissViewController() {
    self.dismiss(animated: true)
  }
}

extension SearchCityViewController: UISearchBarDelegate {
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    resultTableView.reloadData()
    WebManager().fetchCityCoordinates(for: searchText) { result in
      switch result {
      case .success(let success):
        DispatchQueue.main.async {
          self.resultForTableView = success
        }
      case .failure(let failure):
        print(failure.localizedDescription)
      }
    }
  }
}

extension SearchCityViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? ResultTableViewCell else { fatalError("Expected ResultTableViewCel")
    }
    resultForTableView.forEach { item in
      cell.configureLabels(mainText: item.name, secondaryText: item.displayName)
    }
    return cell
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return resultForTableView.count
  }
}

extension SearchCityViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let alertController = UIAlertController(title: "search_alert_title".localized, message: "search_alert_message1".localized + resultForTableView[indexPath.row].name + "search_alert_message2".localized, preferredStyle: .alert)
    let cancelAction = UIAlertAction(title: "cancel".localized, style: .cancel)
    let action = UIAlertAction(title: "OK", style: .default) { _ in
      CitiesCoordinatesModel.shared.addCityCoordinatesToArray(self.resultForTableView[indexPath.row])
      Storage.shared.saveCityCoordinates(CitiesCoordinatesModel.shared.getAllCitiesCoordinates())
      self.dissmissViewController()
      self.delegateFirstViewController?.pushFromSelf()
      self.delegateReloadCities?.reload()
    }
    alertController.addAction(action)
    alertController.addAction(cancelAction)
    self.present(alertController, animated: true)
  }
}
