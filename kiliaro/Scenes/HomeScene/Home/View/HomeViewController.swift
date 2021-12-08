//
//  HomeViewController.swift
//  kiliaro
//
//  Created by Emad Bayramy on 12/4/21.
//

import UIKit

class HomeViewController: UIViewController, Storyboarded {
    
    // MARK: - Coordinator
    weak var coordinator: HomeCoordinator?
    
    // MARK: - ViewModel
    private let homeVM: HomeVM = HomeVM(homeService: HomeService.shared)
    
    // MARK: - IBOutlets
    // Not using weak IBOultet because: https://stackoverflow.com/a/31395938
    @IBOutlet var collectionView: UICollectionView!
    
    // MARK: - Properties
    private var dataSource: KiliaroCollectionViewDataSource<HomeImageCVCell>!
    
    // MARK: - Button To Reload All Cached and Saved Files
    lazy var refreshBtn: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .refresh,
                                     target: self,
                                     action: #selector(reloadAllData(_:)))
        return button
    }()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupBinding()
        callService()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK: - SetupView
    private func setupView() {
        // CollectionView
        dataSource = KiliaroCollectionViewDataSource(items: [], collectionView: collectionView, delegate: self)
        collectionView.dataSource = dataSource
        collectionView.delegate = dataSource
        collectionView.contentInset.top = 10
        collectionView.isPrefetchingEnabled = false
        
        // Title
        title = LocalizedStrings.myImages.value

        // right bar button
        self.navigationItem.setRightBarButton(refreshBtn, animated: true)
        
    }
    
    private func showMessage(title: String = "Error", message: String, buttonTitle: String = "Ok") {
        let ac = UIAlertController(title: title,
                                    message: message,
                                    preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: buttonTitle, style: .default, handler: nil))
        self.present(ac, animated: true, completion: nil)
    }
    
    // MARK: - Bindings
    private func setupBinding() {
        
        // Subscribe to Loading
        homeVM.loading = { [weak self] isLoading in
            guard let self = self else { return }
            self.view.isUserInteractionEnabled = !isLoading
            isLoading ? self.view.animateActivityIndicator() : self.view.removeActivityIndicator()
        }
        // subscribe to ImageResponse
        homeVM.images = { [weak self] images in
            guard let self = self else { return }
            // Show Images to collectionView
            self.dataSource.refreshWithNewItems(images)
        }
        
        // subscribe to Errors
        homeVM.errorHandler = { [weak self] error in
            guard let self = self else { return }
            self.showMessage(message: error)
        }
        
        homeVM.downloadHandler = { [weak self] previewModel in
            guard let self = self else { return }
            self.previewImage(previewModel)
        }
    }
    
    @objc private func reloadAllData(_ button: UIBarButtonItem) {
        homeVM.refreshAllCachedFilesAndReload()
    }
    
    private func previewImage(_ model: PreviewItemModel) {
        DispatchQueue.main.async {
            self.coordinator?.toPreviewImage(item: model)
        }
    }
    
    // MARK: - Services
    private func callService() {
        homeVM.getImages()
    }
}

extension HomeViewController: KiliaroCollectionViewDelegate {
    
    func colelction<T>(didSelectModelAt model: T) {
        guard let model = model as? HomeImageModel else { return }
        homeVM.downloadfile(from: model)
    }
    
}
