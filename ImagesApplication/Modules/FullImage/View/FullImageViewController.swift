//
//  FullImageViewController.swift
//  ImagesApplication
//
//  Created by Арсений Убский on 30.05.2025.
//
import UIKit

final class FullImageViewController: UIViewController {
    private var viewModel: FullImageViewModelProtocol
    
    private let scrollView = UIScrollView()
    private let imageView = UIImageView()
    private let closeButton = UIButton(type: .system)
    
    init(viewModel: FullImageViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        setupBindings()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupBindings()
        viewModel.loadImage()
    }
    
    private func setupViews() {
        view.backgroundColor = .black
        modalPresentationStyle = .fullScreen
        
        scrollView.minimumZoomScale = Constants.scrollViewMinZoom
        scrollView.maximumZoomScale = Constants.scrollViewMaxZoom
        scrollView.delegate = self
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(imageView)
        
        closeButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        closeButton.tintColor = .white
        closeButton.backgroundColor = UIColor(white: 0, alpha: 0.5)
        closeButton.layer.cornerRadius = 20
        closeButton.addTarget(self, action: #selector(dismissSelf), for: .touchUpInside)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(closeButton)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            imageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            imageView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
            imageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor),
            
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                             constant: Constants.closeButtonSpacing),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                  constant: -Constants.closeButtonSpacing),
            closeButton.widthAnchor.constraint(equalToConstant: Constants.closeButtonSize),
            closeButton.heightAnchor.constraint(equalToConstant: Constants.closeButtonSize)
        ])
    }
    
    private func setupBindings() {
        viewModel.onImageLoaded = { [weak self] in
            DispatchQueue.main.async {
                self?.imageView.image = self?.viewModel.image
            }
        }
    }
    
    @objc private func dismissSelf() {
        dismiss(animated: true)
    }
}

extension FullImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        centerImage()
    }
    
    private func centerImage() {
        let boundsSize = scrollView.bounds.size
        var frameToCenter = imageView.frame
        
        if frameToCenter.size.width < boundsSize.width {
            frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2
        } else {
            frameToCenter.origin.x = 0
        }
        
        if frameToCenter.size.height < boundsSize.height {
            frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2
        } else {
            frameToCenter.origin.y = 0
        }
        
        imageView.frame = frameToCenter
    }
}
