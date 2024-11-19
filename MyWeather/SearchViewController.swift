//
//  SearchViewController.swift
//  MyWeather
//
//  Created by Illia Verezei on 18.11.2024.
//

import UIKit

class SearchViewController: UIViewController {
  
  lazy private var toolBar = UIToolbar()
  lazy private var searchBar = UISearchBar()
  //TODO: lazy private var resultTableView
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    setupToolBar(toolBar)
    setupSearchBar(searchBar)
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
  
  @objc private func dissmissViewController() {
    self.dismiss(animated: true)
  }
}

extension SearchViewController: UISearchBarDelegate {
  //TODO: delegates
}
