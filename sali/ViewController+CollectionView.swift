//
//  ViewController+CollectionView.swift
//  n11Clone
//
//  Created by enes.uludag on 7.06.2026.
//

import UIKit

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? viewModel.horizontalProducts.count : viewModel.verticalProducts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HorizontalCell.identifier, for: indexPath) as! HorizontalCell
            let product = viewModel.horizontalProducts[indexPath.row]
            cell.configure(with: product)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VerticalCell.identifier, for: indexPath) as! VerticalCell
            let product = viewModel.verticalProducts[indexPath.row]
            cell.configure(with: product)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let product = indexPath.section == 0 ? viewModel.horizontalProducts[indexPath.row] : viewModel.verticalProducts[indexPath.row]

        if let detailVC = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController {
            detailVC.viewModel = DetailViewModel(product: product)
            
            if let navigationController = self.navigationController {
                navigationController.pushViewController(detailVC, animated: true)
            } else {
                detailVC.modalPresentationStyle = .fullScreen
                self.present(detailVC, animated: true, completion: nil)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.section == 1 && indexPath.row == viewModel.verticalProducts.count - 1 {
            viewModel.loadNextPage()
        }
    }
}
