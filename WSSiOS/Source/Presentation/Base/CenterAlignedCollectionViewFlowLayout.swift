//
//  CenterAlignedCollectionViewFlowLayout.swift
//  WSSiOS
//
//  Created by Hyowon Jeon on 9/13/24.
//

import UIKit

class CenterAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let attributes = super.layoutAttributesForElements(in: rect) else { return nil }

        var rowItems: [UICollectionViewLayoutAttributes] = []
        var currentRowY: CGFloat = -1.0

        attributes.forEach { layoutAttribute in
            if layoutAttribute.frame.origin.y != currentRowY {
                centerAlignRow(rowItems)
                rowItems.removeAll()
                currentRowY = layoutAttribute.frame.origin.y
            }
            rowItems.append(layoutAttribute)
        }
        
        centerAlignRow(rowItems)
        return attributes
    }

    private func centerAlignRow(_ rowItems: [UICollectionViewLayoutAttributes]) {
        guard let collectionView = collectionView, !rowItems.isEmpty else { return }

        let totalWidth = rowItems.reduce(0) { $0 + $1.frame.width } + CGFloat(rowItems.count - 1) * minimumInteritemSpacing
        let padding = (collectionView.bounds.width - totalWidth - sectionInset.left - sectionInset.right) / 2

        var leftMargin = sectionInset.left + padding
        rowItems.forEach { layoutAttribute in
            layoutAttribute.frame.origin.x = leftMargin
            leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing
        }
    }
}
