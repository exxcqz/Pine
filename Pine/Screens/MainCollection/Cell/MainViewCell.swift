//
//  MainCollectionCell.swift
//  Pine
//
//  Created by Nikita Gavrikov on 24.02.2022.
//

import UIKit

class MainViewCell: UICollectionViewCell {
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .black
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let transparentRectangleView: UIView = {
        let rectangle = UIView()
        rectangle.backgroundColor = .black
        rectangle.alpha = 0.2
        rectangle.translatesAutoresizingMaskIntoConstraints = false
        return rectangle
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .proTextFontMedium(ofSize: 14)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let shareButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: Icons.icShareWhite), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private var task: URLSessionDataTask?

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        imageView.addSubview(transparentRectangleView)
        imageView.addSubview(nameLabel)
        contentView.addSubview(shareButton)
        setConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureImagesCell(imageInfo: ImageData) {
        imageView.image = nil
        if let task = task {
            task.cancel()
        }
        guard let url = URL(string: imageInfo.urls.small) else { return }
        if let userInfoFromCache = CacheManager.cache.object(forKey: url.absoluteString as AnyObject) as? (image: UIImage, userName: String) {
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
            }
        }
        task?.resume()
    }
}

// MARK: - SetConstraints

extension MainViewCell {

    private func setConstraints() {
        NSLayoutConstraint.activate([
            imageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0),
            imageView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0),
            imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0)
        ])

        NSLayoutConstraint.activate([
            transparentRectangleView.leftAnchor.constraint(equalTo: self.imageView.leftAnchor, constant: 0),
            transparentRectangleView.rightAnchor.constraint(equalTo: self.imageView.rightAnchor, constant: 0),
            transparentRectangleView.bottomAnchor.constraint(equalTo: self.imageView.bottomAnchor, constant: 0),
            transparentRectangleView.topAnchor.constraint(equalTo: self.imageView.bottomAnchor, constant: -44)

        ])

        NSLayoutConstraint.activate([
            nameLabel.leftAnchor.constraint(equalTo: self.imageView.leftAnchor, constant: 16),
            nameLabel.bottomAnchor.constraint(equalTo: self.imageView.bottomAnchor, constant: -14),
            nameLabel.heightAnchor.constraint(equalToConstant: 16),
            nameLabel.widthAnchor.constraint(equalToConstant: 315)
        ])

        NSLayoutConstraint.activate([
            shareButton.widthAnchor.constraint(equalToConstant: 36),
            shareButton.heightAnchor.constraint(equalToConstant: 36),
            shareButton.rightAnchor.constraint(equalTo: self.imageView.rightAnchor, constant: -8),
            shareButton.bottomAnchor.constraint(equalTo: self.imageView.bottomAnchor, constant: -4),
        ])
    }
}
