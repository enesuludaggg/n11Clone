//
//   HomeViewController.swift
//   sali
//
//   Created by enes.uludag on 11.05.2026.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var sortButton: UIButton!
    
    let viewModel = HomeViewModel()
    private var timer: Timer?
    private var pageCount = 0
    
    deinit {
        stopTimer()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        viewModel.loadData()
    }
    
    @IBAction func sortButton(_ sender: UIButton) {
        let alert = UIAlertController(title: "Sırala", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(createSmartSortAction(for: sender))
        alert.addAction(createPriceAscendingAction(for: sender))
        alert.addAction(createPriceDescendingAction(for: sender))
        alert.addAction(createRatingDescendingAction(for: sender))
        
        alert.addAction(UIAlertAction(title: "İptal", style: .cancel))
        
        self.present(alert, animated: true)
    }
    
    private func setupUI() {
        setupCollectionView()
        setupSearchBar()
        startTimer()
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.setCollectionViewLayout(createLayout(), animated: false)
    }

    private func setupSearchBar() {
        searchBar.delegate = self
        viewModel.delegate = self
        searchBar.layer.borderWidth = 0.5
        searchBar.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        searchBar.layer.cornerRadius = 15
        searchBar.backgroundImage = UIImage()
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { [weak self] _ in
            self?.scrollToNextBanner()
        }
    }
    
    private func scrollToNextBanner() {
        let productCount = viewModel.horizontalProducts.count
        guard productCount > 0 else { return }
        
        pageCount = (pageCount + 1) % productCount
        let indexPath = IndexPath(item: pageCount, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    private func createSmartSortAction(for button: UIButton) -> UIAlertAction {
        return UIAlertAction(title: "Akıllı Sıralama", style: .default) { [weak self] _ in
            self?.viewModel.sortProducts(by: .smart)
            button.setTitle("  Akıllı Sıralama", for: .normal)
        }
    }

    private func createPriceAscendingAction(for button: UIButton) -> UIAlertAction {
        return UIAlertAction(title: "Artan Fiyat", style: .default) { [weak self] _ in
            self?.viewModel.sortProducts(by: .priceAscending)
            button.setTitle("  Artan Fiyat", for: .normal)
        }
    }
    
    private func createPriceDescendingAction(for button: UIButton) -> UIAlertAction {
        return UIAlertAction(title: "Azalan Fiyat", style: .default) { [weak self] _ in
            self?.viewModel.sortProducts(by: .priceDescending)
            button.setTitle("  Azalan Fiyat", for: .normal)
        }
    }
    
    private func createRatingDescendingAction(for button: UIButton) -> UIAlertAction {
        return UIAlertAction(title: "Puan (Azalan)", style: .default) { [weak self] _ in
            self?.viewModel.sortProducts(by: .ratingDescending)
            button.setTitle("  Puan (Azalan)", for: .normal)
        }
    }
}

extension HomeViewController: HomeViewModelDelegate {
    func didUpdateData() {
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
    func didError(_ message: String) {
        print("Hata: \(message)")
    }
}

extension HomeViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.search(query: searchText)
    }
}

extension HomeViewController {
    private func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { section, env in
            if section == 0 {
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(0.9), heightDimension: .absolute(200)), subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .groupPagingCentered
                section.interGroupSpacing = 10
                return section
            } else {
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1)))
                item.contentInsets = .init(top: 5, leading: 5, bottom: 5, trailing: 5)
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(300)), subitems: [item, item])
                let section = NSCollectionLayoutSection(group: group)
                return section
            }
        }
    }
}
