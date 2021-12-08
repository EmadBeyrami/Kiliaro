//
//  UICollectionViewCell.swift
//  kiliaro
//
//  Created by Emad Bayramy on 12/4/21.
//

import UIKit

protocol KiliaroCollectionViewCell: UICollectionViewCell {
    associatedtype CellViewModel
    func configureCellWith(_ item: CellViewModel)
    func configCellSize(item: CellViewModel) -> CGSize
}
