//
//  MainCollectionCell.swift
//  Pine
//
//  Created by Nikita Gavrikov on 24.02.2022.
//

import UIKit

final class MainViewCell: UICollectionViewCell {
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .black
        return imageView
    }()

    private lazy var transparentRectangleView: UIView = {
        let rectangle = UIView()
        rectangle.backgroundColor = .black
        rectangle.alpha = 0.2
        return rectangle
    }()

     lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .proTextFontMedium(ofSize: 14)
        label.textColor = .white
        return label
    }()

    lazy var shareButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: Icons.icShareWhite), for: .normal)
        button.isHidden = true
        return button
    }()

    private var task: URLSessionDataTask?

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        imageView.addSubview(transparentRectangleView)
        imageView.addSubview(nameLabel)
        contentView.addSubview(shareButton)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = .init(
            x: 0,
            y: 0,
            width: contentView.bounds.width,
            height: contentView.bounds.height
        )
        transparentRectangleView.frame = .init(
            x: 0,
            y: contentView.bounds.height - (44 * Layout.scaleFactorW),
            width: contentView.bounds.width,
            height: 44 * Layout.scaleFactorW
        )
        nameLabel.frame = .init(
            x: 16 * Layout.scaleFactorW,
            y: 210 * Layout.scaleFactorW,
            width: 315 * Layout.scaleFactorW,
            height: 16 * Layout.scaleFactorW
        )
        shareButton.frame = .init(
            x: 331 * Layout.scaleFactorW,
            y: 200 * Layout.scaleFactorW,
            width: 36 * Layout.scaleFactorW,
            height: 36 * Layout.scaleFactorW
        )
    }

    func configureImagesCell(imageInfo: ImageData) {
        imageView.image = nil
        if let task = task {
            task.cancel()
        }
        guard let url = URL(string: imageInfo.urls.regular) else { return }
        if let userInfoFromCache = CacheManager.cache.object(
            forKey: url.absoluteString as AnyObject
        ) as? (image: UIImage, userName: String) {
            self.imageView.image = userInfoFromCache.image
            self.nameLabel.text = userInfoFromCache.userName
            return
        }
        task = URLSession.shared.dataTask(with: url) { data, _, _ in
            guard
                let data = data,
                let image = UIImage(data: data)
            else {
                return
            }
            let userName = "\(imageInfo.user?.firstName ?? "") \(imageInfo.user?.lastName ?? "")"
            let userInfo: (UIImage, String) = (image, userName)
            CacheManager.cache.setObject(userInfo as AnyObject, forKey: url.absoluteString as AnyObject)
            DispatchQueue.main.async {
                self.imageView.image = image
                self.nameLabel.text = userName
                self.shareButton.isHidden = false
            }
        }
        task?.resume()
    }
}
