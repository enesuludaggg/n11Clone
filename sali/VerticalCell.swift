//
//  VerticalCell.swift
//  sali
//
//  Created by enes.uludag on 11.05.2026.
//

import UIKit

class VerticalCell: UICollectionViewCell {
    
    static let identifier = "VerticalCell"
    
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var addToCartButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.layer.cornerRadius = 8
        contentView.layer.borderWidth = 0.5
        contentView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        contentView.layer.masksToBounds = true
    }
    
    func configure(with product: Product) {
        titleLabel.text = product.displayName
        
        priceLabel.text = product.formattedPrice
        
        if let rate = product.rate {
            ratingLabel.text = "\(rate)"
        } else {
            ratingLabel.text = "-"
        }
        
        productImageView.loadImage(from: product.image)
    }
}
