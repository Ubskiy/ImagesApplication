//
//  GalleryViewController.swift
//  ImagesApplication
//
//  Created by Арсений Убский on 29.05.2025.
//
import UIKit

final class GalleryViewController: UIViewController {
    private var viewModel: GalleryViewModelProtocol
    private var collectionView: UICollectionView!
    private let cellSize = CGSize(width: Constants.galleryCellSize, height: Constants.galleryCellSize)
    
    init(viewModel: GalleryViewModelProtocol = GalleryViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupViewModel()
        viewModel.loadImageLinks()
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: ThemeManager.shared.currentTheme.buttonTitle,
            style: .plain,
            target: self,
            action: #selector(didTapThemeToggle)
        )

    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { _ in
            self.collectionView.collectionViewLayout.invalidateLayout()
        })
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = Constants.collectionViewSpacing
        layout.minimumLineSpacing = Constants.collectionViewSpacing
        layout.sectionInset = UIEdgeInsets(top: Constants.collectionViewInset,
                                           left: Constants.collectionViewInset,
                                           bottom: Constants.collectionViewInset,
                                           right: Constants.collectionViewInset)
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        collectionView.register(GalleryCollectionViewCell.self, forCellWithReuseIdentifier: GalleryCollectionViewCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        view.addSubview(collectionView)
    }
    
    private func setupViewModel() {
        viewModel.onUpdate = { [weak self] in
            self?.collectionView.reloadData()
        }
        
        viewModel.onError = { [weak self] error in
            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Retry", style: .default) { _ in
                self?.viewModel.loadImageLinks()
            })
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            self?.present(alert, animated: true)
        }
    }
    
    @objc private func didTapThemeToggle() {
        ThemeManager.shared.toggleTheme()
        navigationItem.rightBarButtonItem?.title = ThemeManager.shared.currentTheme.buttonTitle
    }

}

extension GalleryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.imageURLs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: GalleryCollectionViewCell.identifier,
            for: indexPath
        ) as? GalleryCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(with: nil, isLoading: true, isError: false)
        
        viewModel.loadImage(for: indexPath.item) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let image):
                    let previewImage = image?.resized(to: CGSize(width: Constants.galleryPreviewImageSize,
                                                                 height: Constants.galleryPreviewImageSize))
                    cell.configure(with: previewImage, isLoading: false, isError: false)
                case .failure:
                    cell.configure(with: nil, isLoading: false, isError: true)
                }
            }
        }
        
        return cell
    }
}

extension GalleryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSize
    }
}

extension GalleryViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let url = viewModel.imageURLs[indexPath.item]
        let model = FullImageModel(imageURL: url)
        let viewModel = FullImageViewModel(imageURL: url, model: model)
        let fullVC = FullImageViewController(viewModel: viewModel)
        present(fullVC, animated: true)
    }
}
