//
//  ImageViewController.swift
//  Pine
//
//  Created by Nikita Gavrikov on 25.02.2022.
//

import UIKit

class DetailImageViewController: UIViewController {
    private let imageView: UIImageView = {
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

    private let shareButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: Icons.icShareWhite), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private let scaleWidth = UIScreen.main.bounds.size.width / 375

    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        setConstraint()
        changeNavigationBar()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.barStyle = .black
    }

    private func setViews() {
        view.backgroundColor = .black
        view.addSubview(imageView)
        view.addSubview(nameLabel)
        view.addSubview(transparentRectangleView)
        view.addSubview(shareButton)
    }

    private func changeNavigationBar() {
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: Icons.icBack)
        navigationController?.navigationBar.topItem?.title = ""
        navigationController?.navigationBar.tintColor = .white
    }

    func setImage(imageInfo: ImageData) {
        let url = imageInfo.urls.regular
        NetworkDataFetch.shared.fetchImage(urlImage: url) { image in
            self.imageView.image = image
            let nameUser = "\(imageInfo.user?.firstName ?? "") \(imageInfo.user?.lastName ?? "")"
            self.nameLabel.text = nameUser
            let widthView = self.view.bounds.width
            let scale = widthView / CGFloat(imageInfo.width)
            if imageInfo.width < imageInfo.height {
                NSLayoutConstraint.activate([
                    self.imageView.heightAnchor.constraint(
                        equalToConstant: 690 * self.scaleWidth
                    ),
                    self.imageView.widthAnchor.constraint(
                        equalToConstant: widthView
                    ),
                    self.imageView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
                ])

            } else {
                NSLayoutConstraint.activate([
                    self.imageView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
                    self.imageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                    self.imageView.heightAnchor.constraint(
                        equalToConstant: CGFloat(imageInfo.height) * scale
                    ),
                    self.imageView.widthAnchor.constraint(
                        equalToConstant: widthView
                    )
                ])
            }
        }
    }
}

// MARK: - SetConstraint
extension DetailImageViewController {

    private func setConstraint() {
        NSLayoutConstraint.activate([
            transparentRectangleView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),
            transparentRectangleView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0),
            transparentRectangleView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            transparentRectangleView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -44)
        ])

        NSLayoutConstraint.activate([
            nameLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16),
            nameLabel.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -14),
            nameLabel.heightAnchor.constraint(equalToConstant: 16),
            nameLabel.widthAnchor.constraint(equalToConstant: 315)
        ])

        NSLayoutConstraint.activate([
            shareButton.widthAnchor.constraint(equalToConstant: 36),
            shareButton.heightAnchor.constraint(equalToConstant: 36),
            shareButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -8),
            shareButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -4),
        ])
    }
}
