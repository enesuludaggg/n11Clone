//
//  ViewController.swift
//  sali
//
//  Created by enes.uludag on 11.05.2026.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var sortButton: UIButton!
    
    
    private let viewModel = HomeViewModel()
    private var timer: Timer?
    private var sayfaSayi = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        viewModel.loadData()
    }
    
    @IBAction func sortButton(_ sender: UIButton) {
            let alert = UIAlertController(title: "Sırala", message: nil, preferredStyle: .actionSheet)
            
            alert.addAction(UIAlertAction(title: "Akıllı Sıralama", style: .default) { _ in
                self.viewModel.sortProducts(by: 0)
                sender.setTitle("  Akıllı Sıralama", for: .normal)
            })
        
            alert.addAction(UIAlertAction(title: "Artan Fiyat", style: .default) { _ in
                self.viewModel.sortProducts(by: 1)
                sender.setTitle("  Artan Fiyat", for: .normal)
            })
            
            alert.addAction(UIAlertAction(title: "Azalan Fiyat", style: .default) { _ in
                self.viewModel.sortProducts(by: 2)
                sender.setTitle("  Azalan Fiyat", for: .normal)
            })
            
            alert.addAction(UIAlertAction(title: "Puan (Azalan)", style: .default) { _ in
                self.viewModel.sortProducts(by: 3)
                sender.setTitle("  Puan (Azalan)", for: .normal)
            })
         
            self.present(alert, animated: true)
    }
    
    private func setupUI() {
        collectionView.delegate = self
        collectionView.dataSource = self
        searchBar.delegate = self
        viewModel.delegate = self
        searchBar.layer.borderWidth = 0.5
        searchBar.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        searchBar.layer.cornerRadius = 15
        searchBar.backgroundImage = UIImage()
        
        
        collectionView.setCollectionViewLayout(createLayout(), animated: false)
        
        startTimer()
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { [weak self] _ in
            self?.scrollToNextBanner()
        }
    }
    
    private func scrollToNextBanner() {
        let count = viewModel.horizontalProducts.count
        guard count > 0 else { return }
        
        sayfaSayi = (sayfaSayi + 1) % count
        let indexPath = IndexPath(item: sayfaSayi, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
}

extension ViewController: HomeViewModelDelegate {
    func didUpdateData() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func didError(_ message: String) {
        print("Hata: \(message)")
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? viewModel.horizontalProducts.count : viewModel.verticalProducts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HorizontalCell", for: indexPath) as! HorizontalCell
            let product = viewModel.horizontalProducts[indexPath.row]
            cell.configure(with: product)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VerticalCell", for: indexPath) as! VerticalCell
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

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.search(query: searchText)
    }
}

extension ViewController {
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

extension UIImageView {
    func loadImage(from urlString: String?) {
        guard let urlString = urlString, let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self?.image = image
                }
            }
        }.resume()
    }
}
