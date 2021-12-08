//
//  HomeVM.swift
//  kiliaro
//
//  Created by Emad Bayramy on 12/6/21.
//

import Foundation

class HomeVM {
    
    // MARK: - initializer
    private var homeService: HomeServiceProtocol
    init(homeService: HomeServiceProtocol) {
        self.homeService = homeService
    }
    
    // MARK: - Publishers
    var loading: DataCompletion<Bool>?
    
    var images: DataCompletion<HomeImagesModel>?
    var errorHandler: DataCompletion<String>?
    var downloadHandler: DataCompletion<PreviewItemModel>?
    
    func getImages() {
        loading?(true)
        homeService.getImages { [weak self] result in
            guard let self = self else { return }
            self.loading?(false)
            switch result {
            case .success(let images):
                self.images?(images)
            case .failure(let error):
                self.errorHandler?(error.localizedDescription)
            }
        }
    }
    
    func downloadfile(from model: HomeImageModel) {
        guard let url = model.downloadURL else {
            errorHandler?("er")
            return
        }
        loading?(true)
        homeService.downloadImage(url: url) { [weak self] (success, fileLocation) in
            guard let self = self else  { return }
            self.loading?(false)
            if let url = fileLocation, success {
                let previewModel = self.generatePreviewModelFrom(model, url: url)
                self.downloadHandler?(previewModel)
            } else {
                self.errorHandler?("error on Download")
            }
        }
    }
    
    // MARK: Remove Cache and refresh
    func refreshAllCachedFilesAndReload() {
        FilesManager.standard.removeAllFiles()
        CacheManager.standard.clearAllCache()
        getImages()
    }
    
    // MARK: - Private Functions
    private func generatePreviewModelFrom(_ model: HomeImageModel, url: URL) -> PreviewItemModel {
        let previewModel = PreviewItemModel(displayName: model.createdAt?.toDate() ?? "hello", fileName: model.filename ?? "image", url: url)
        return previewModel
    }
}
