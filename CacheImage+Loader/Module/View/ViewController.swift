//
//  ViewController.swift
//  MVVM+Practice
//
//  Created by Murtaza Mehmood on 01/01/2023.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: - OUTLETS
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - PROPERTIES
    var viewModel: ProductViewModel
    
    required init?(coder: NSCoder) {
        viewModel = ProductViewModel(networking: APIHandler())
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupTableView()
        loadData()
    }
    
    func loadData() {
        viewModel.fetchProductsCompletion = { [weak self] error in
            guard error == nil else {return}
            self?.tableView.reloadData()
        }
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(ProductTableViewCell.nib, forCellReuseIdentifier: ProductTableViewCell.Identifier)
    }


}

//MARK: - TABLEVIEW DELEGATE DATASOURCE
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProductTableViewCell.Identifier, for: indexPath) as! ProductTableViewCell
        guard let model = viewModel.getProduct(index: indexPath.row) else {return cell}
        cell.configureCell(title: model.title,
                           price: model.price,
                           description: model.description,
                           image: model.image)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
}
