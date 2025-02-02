//
//  SearchViewController.swift
//  MyWeather
//
//  Created by Illia Verezei on 18.11.2024.
//

import UIKit

class SearchCityViewController: UIViewController {
  
  private var presenter: SearchCityViewPresenterProtocol?
  
  lazy private var toolBar = UIToolbar()
  lazy private var searchBar = UISearchBar()
  lazy private var resultTableView = UITableView()
  lazy private var alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    setupToolBar(toolBar)
    setupSearchBar(searchBar)
    setupTableView(resultTableView)
  }
  
  func setPresenter(presenter: SearchCityViewPresenterProtocol) {
    self.presenter = presenter
  }
  
  private func setupToolBar(_ bar: UIToolbar) {
    bar.barTintColor = .systemBackground
    bar.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(bar)
    
    NSLayoutConstraint.activate([
      bar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      bar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      bar.trailingAnchor.constraint(equalTo: view.trailingAnchor)
    ])
    
    let cancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action:  #selector(dissmissViewController))
    cancel.tintColor = .colorForTextTheme
    
    toolBar.items = [
      cancel,
      UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
      UIBarButtonItem(customView: SearchTitleView()),
      UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    ]
  }
  
  private func setupSearchBar(_ bar: UISearchBar) {
    bar.placeholder = "searchbar_placeholder".localized
    bar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
    bar.backgroundColor = .systemBackground
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
    presenter?.didTapCancelButton(from: self)
  }
}

extension SearchCityViewController: SearchCityViewProtocol {
  func reloadTableView() {
    resultTableView.reloadData()
  }
  
  func prepareAlert(
    title: String,
    message: String,
    cancelTitle: String,
    actionHandler: @escaping (UIAlertAction) -> ()
  )
  {
    alert.title = title
    alert.message = message
    let cancelAction = UIAlertAction(title: cancelTitle , style: .cancel)
    let action = UIAlertAction(title: "OK", style: .default, handler: actionHandler)
    alert.addAction(action)
    alert.addAction(cancelAction)
  }
}

extension SearchCityViewController: UISearchBarDelegate {
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    presenter?.searchTextDidChange(text: searchText)
  }
}

extension SearchCityViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? ResultTableViewCell else { fatalError("Expected ResultTableViewCel")
    }
    let result = presenter?.getResult(for: indexPath.row)
    if let result = result {
      cell.configureLabels(mainText: result.name, secondaryText: result.displayName)
    }
    return cell
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    presenter?.getNumberOfItems() ?? 0
  }
}

extension SearchCityViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    presenter?.didTapOnCity(index: indexPath.row, from: self)
    self.present(alert, animated: true)
  }
}
