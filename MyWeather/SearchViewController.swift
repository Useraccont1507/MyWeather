//
//  SearchViewController.swift
//  MyWeather
//
//  Created by Illia Verezei on 18.11.2024.
//

import UIKit

class SearchViewController: UIViewController {
  
  private var searchResultForTableView: [CityElement] = []
  
  lazy private var toolBar = UIToolbar()
  lazy private var searchBar = UISearchBar()
  lazy private var resultTableView = UITableView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    setupToolBar(toolBar)
    setupSearchBar(searchBar)
    setupTableView(resultTableView)
  }
  
  private func setupToolBar(_ bar: UIToolbar) {
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
    tableView.register(SearchResultTableViewCell.self, forCellReuseIdentifier: "cell")
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

extension SearchViewController: UISearchBarDelegate {
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    resultTableView.reloadData()
    print("table view reloaded")
    WebManager().fetchCityCoordinates(for: searchText) { result in
      switch result {
      case .success(let success):
        DispatchQueue.main.async {
          self.searchResultForTableView = success
        }
      case .failure(let failure):
        print(failure.localizedDescription)
      }
    }
  }
}

extension SearchViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? SearchResultTableViewCell else { fatalError("Expected SearchResultTableViewCel")
    }
    for item in searchResultForTableView {
      cell.configureLabels(mainText: item.name, secondaryText: item.displayName)
    }
    return cell
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    searchResultForTableView.count
  }
}

extension SearchViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let alertController = UIAlertController(title: "search_alert_title".localized, message: "search_alert_message1".localized + searchResultForTableView[indexPath.row].name + "search_alert_message2".localized, preferredStyle: .alert)
    let cancelAction = UIAlertAction(title: "cancel".localized, style: .cancel)
    let action = UIAlertAction(title: "OK", style: .default) { _ in
      
    }
    alertController.addAction(action)
    alertController.addAction(cancelAction)
    self.present(alertController, animated: true)
  }
}
