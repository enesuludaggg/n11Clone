//
//  DetailViewController.swift
//  sali
//
//  Created by enes.uludag on 11.05.2026.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var addToCartButton: UIButton!
    @IBOutlet weak var buyNowButton: UIButton!
    
    var viewModel: DetailViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        guard let vm = viewModel else { return }
        
        titleLabel.text = vm.title
        priceLabel.text = vm.price
        rateLabel.text = vm.rateText
        productImageView.loadImage(from: vm.imageUrl)
        
        addToCartButton.layer.cornerRadius = 8
        addToCartButton.layer.borderWidth = 1
        addToCartButton.layer.borderColor = UIColor.systemGray4.cgColor
        buyNowButton.layer.cornerRadius = 8
    }
}
