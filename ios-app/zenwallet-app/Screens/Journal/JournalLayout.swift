//
//  JournalLayout.swift
//  zenwallet-app
//
//  Created by Nguyễn Minh An on 15/11/25.
//

import Foundation
import UIKit

protocol JournalLayoutDelegate: AnyObject {
    func journalItemType(at indexPath: IndexPath) -> JournalCardType
    func journalContentHeight(at indexPath: IndexPath) -> CGFloat
}

final class JournalLayout: UICollectionViewLayout {

    weak var delegate: JournalLayoutDelegate?

    // MARK: - Config
    private let numberOfColumns: Int = UIDevice.current.userInterfaceIdiom == .pad ? 3 : 2
    private let cellPadding: CGFloat = 8

    // Cache
    private var cache: [UICollectionViewLayoutAttributes] = []

    private var contentHeight: CGFloat = 0
    private var contentWidth: CGFloat {
        guard let cv = collectionView else { return 0 }
        return cv.bounds.width - (cv.contentInset.left + cv.contentInset.right)
    }

    override var collectionViewContentSize: CGSize {
        CGSize(width: contentWidth, height: contentHeight)
    }

    override func prepare() {
        super.prepare()

        guard cache.isEmpty, let cv = collectionView else { return }

        let columnWidth = contentWidth / CGFloat(numberOfColumns)
        let xOffset = (0 ..< numberOfColumns).map { CGFloat($0) * columnWidth }
        var yOffset = [CGFloat](repeating: 0, count: numberOfColumns)

        for item in 0 ..< cv.numberOfItems(inSection: 0) {

            let indexPath = IndexPath(item: item, section: 0)

            guard let delegate = delegate else { continue }

            // MARK: - Dynamic height based on item type
            let itemType = delegate.journalItemType(at: indexPath)
            let textHeight = delegate.journalContentHeight(at: indexPath)

            let itemHeight = height(for: itemType, baseTextHeight: textHeight)

            // Pick column with smallest Y
            let column = yOffset.firstIndex(of: yOffset.min()!) ?? 0

            let frame = CGRect(
                x: xOffset[column],
                y: yOffset[column],
                width: columnWidth,
                height: itemHeight
            )

            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)

            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            cache.append(attributes)

            contentHeight = max(contentHeight, frame.maxY)
            yOffset[column] += itemHeight
        }
    }

    override func layoutAttributesForElements(in rect: CGRect)
        -> [UICollectionViewLayoutAttributes]? {
        return cache.filter { $0.frame.intersects(rect) }
    }

    override func layoutAttributesForItem(at indexPath: IndexPath)
        -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.item]
    }

    override func invalidateLayout() {
        cache.removeAll()
        super.invalidateLayout()
    }
}

private extension JournalLayout {

    func height(for type: JournalCardType, baseTextHeight: CGFloat) -> CGFloat {
        switch type {

        case .quote:
            return baseTextHeight + 80  // top/bottom + icon + padding

        case .autoSummary:
            return baseTextHeight + 60

        case .rate:
            return 120  // fixed height cell

        case .question:
            return baseTextHeight + 70

        case .note:
            return baseTextHeight + 40
        }
    }
}
