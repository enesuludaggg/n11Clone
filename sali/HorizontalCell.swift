//
//  HorizontalCell.swift
//  sali
//
//  Created by enes.uludag on 11.05.2026.
//

import UIKit

class HorizontalCell: UICollectionViewCell {
    
    static let identifier = "HorizontalCell"
    
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var addToCartButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupLayer()
    }
    
    private func setupLayer() {
        contentView.layer.cornerRadius = 8
        contentView.layer.borderWidth = 0.5
        contentView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        contentView.layer.masksToBounds = true
    }
    
    func configure(with product: Product) {
        titleLabel.text = product.displayName
        
        priceLabel.text = product.formattedPrice
        
        productImageView.loadImage(from: product.image)
    }
}

extension Optional where Wrapped == Double {
    var asRatingString: String {
        if let rate = self {
            return "\(rate)"
        } else {
            return "-"
        }
    }
}
