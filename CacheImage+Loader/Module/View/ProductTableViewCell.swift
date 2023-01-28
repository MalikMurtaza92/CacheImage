//
//  ProductTableViewCell.swift
//  MVVM+Practice
//
//  Created by Murtaza Mehmood on 26/01/2023.
//

import UIKit

class ProductTableViewCell: UITableViewCell {
    
    //MARK: - OUTLETS
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productDescription: UILabel!
    @IBOutlet weak var productImage: CacheImage!
    
    //MARK: - PROPERTIES
    class var Identifier: String {
        return "ProductTableViewCell"
    }
    
    class var nib: UINib {
        return UINib(nibName: "ProductTableViewCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(title: String,price: Double,description: String,image url: String) {
        productTitle.text = title
        productPrice.text = "price"
        productDescription.text = description
        productImage.downloadImage(image: url, placeholder: nil)
    }
    
}
