//
//  HomeImageCVCell.swift
//  kiliaro
//
//  Created by Emad Bayramy on 12/6/21.
//

import UIKit

class HomeImageCVCell: UICollectionViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet var thumbnailImageView: UIImageView!
    @IBOutlet var sizeLabel: UILabel!
    
    // MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        initialize()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnailImageView.image = nil
        sizeLabel.text = ""
    }
    
    // MARK: - setupView
    private func initialize() {
        setCornerRadius(20)
        sizeLabel.backgroundColor = UIColor.kiliaroOrange.withAlphaComponent(0.5)
    }
    
    // MARK: - Setters and Getters
    private func fill(_ model: HomeImageModel) {
        let thumbnailSizeQuery = setThumbnailSize(model: model)
        let thumbnailURL = (model.thumbnailURL ?? "") + thumbnailSizeQuery
        if let url = URL(string: thumbnailURL) {
            thumbnailImageView.load(url: url)
        }
        setSizeText(model.size ?? 0)
    }
    
    private func setThumbnailSize(model: HomeImageModel) -> String {
        let size = configCellSize(item: model)
        let resize = ThumbnailResizableModel(mode: .crop, height: size.height, width: size.width)
        return resize.getQuery()
    }
    
    private func setSizeText(_ size: Int64) {
        let size = ReadableUnitDecorator(bytes: size).getReadableUnit()
        sizeLabel.text = LocalizedStrings.size.value + size
    }
}

// MARK: - KiliaroCollectionViewCell
extension HomeImageCVCell: KiliaroCollectionViewCell {
    
    func configureCellWith(_ item: HomeImageModel) {
        fill(item)
    }
    
    func configCellSize(item: HomeImageModel) -> CGSize {
        let deviceWidth = UIScreen.main.bounds.width
        return CGSize(width: (deviceWidth - 12) / 3, height: 130)
    }
}
