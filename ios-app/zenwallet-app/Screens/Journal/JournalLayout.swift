//
//  JournalLayout.swift
//  zenwallet-app
//
//  Created by Nguyễn Minh An on 15/11/25.
//

import Foundation
import UIKit

protocol JournalLayoutDelegate: AnyObject {
    func journalItemType(at indexPath: IndexPath) -> JournalCardType // Giữ lại nếu cần cho logic khác
    func journalContentHeight(at indexPath: IndexPath) -> CGFloat // Chiều cao cell + padding trên/dưới
}

final class JournalLayout: UICollectionViewLayout {

    weak var delegate: JournalLayoutDelegate?

    // MARK: - Config
    // Thay đổi thành `let` thay vì `private let` để có thể truy cập từ VC
    let numberOfColumns: Int = UIDevice.current.userInterfaceIdiom == .pad ? 3 : 2
    let cellPadding: CGFloat = 4

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

        // Phải đảm bảo cache.isEmpty để không tính toán lại khi không cần
        guard cache.isEmpty, let cv = collectionView else { return }

        let columnWidth = contentWidth / CGFloat(numberOfColumns)
        let xOffset = (0 ..< numberOfColumns).map { CGFloat($0) * columnWidth }
        var yOffset = [CGFloat](repeating: 0, count: numberOfColumns)

        for item in 0 ..< cv.numberOfItems(inSection: 0) {

            let indexPath = IndexPath(item: item, section: 0)

            guard let delegate = delegate else { continue }

            // MARK: - Dynamic height: Lấy chiều cao ĐÃ HOÀN THIỆN từ Delegate
            // itemHeight là chiều cao cell + padding trên/dưới
            let itemHeight = delegate.journalContentHeight(at: indexPath)
            
            // Pick column with smallest Y
            let column = yOffset.firstIndex(of: yOffset.min()!) ?? 0

            let frame = CGRect(
                x: xOffset[column],
                y: yOffset[column],
                width: columnWidth,
                height: itemHeight
            )

            // Inset frame để tạo khoảng trống (cellPadding) giữa các cell và mép collectionView
            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)

            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            cache.append(attributes)

            contentHeight = max(contentHeight, frame.maxY)
            // Tiến yOffset xuống bằng tổng chiều cao (cell + padding)
            yOffset[column] += itemHeight
        }
    }

    override func layoutAttributesForElements(in rect: CGRect)
        -> [UICollectionViewLayoutAttributes]? {
        return cache.filter { $0.frame.intersects(rect) }
    }

    override func layoutAttributesForItem(at indexPath: IndexPath)
        -> UICollectionViewLayoutAttributes? {
        // Cần đảm bảo không bị Index Out of Range nếu gọi trước khi prepare chạy
        guard indexPath.item < cache.count else { return nil }
        return cache[indexPath.item]
    }

    override func invalidateLayout() {
        cache.removeAll()
        contentHeight = 0 // Reset contentHeight
        super.invalidateLayout()
    }
}

// BỎ HOÀN TOÀN private extension JournalLayout CŨ (chứa hàm height)
