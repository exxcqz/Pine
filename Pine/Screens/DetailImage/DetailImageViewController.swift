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

    private let firstNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Hello"
        label.font = .proTextFontMedium(ofSize: 14)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let lastNameLabel: UILabel = {
        let label = UILabel()
        label.font = .proTextFontMedium(ofSize: 14)
        label.text = "World"
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

    private let transparentRectangleView: UIView = {
        let rectangle = UIView()
        rectangle.backgroundColor = .black
        rectangle.alpha = 0.2
        rectangle.translatesAutoresizingMaskIntoConstraints = false
        return rectangle
    }()

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
        view.addSubview(firstNameLabel)
        view.addSubview(lastNameLabel)
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
            self.firstNameLabel.text = imageInfo.user?.firstName
            self.lastNameLabel.text = imageInfo.user?.lastName
            let widthView = self.view.bounds.width
            let scale = widthView / CGFloat(imageInfo.width)
            if imageInfo.width < imageInfo.height {
                self.imageView.heightAnchor.constraint(
                    equalToConstant: CGFloat(imageInfo.height) * scale
                ).isActive = true
                self.imageView.widthAnchor.constraint(
                    equalToConstant: widthView
                ).isActive = true
            } else {
                self.imageView.heightAnchor.constraint(
                    equalToConstant: CGFloat(imageInfo.height) * scale
                ).isActive = true
                self.imageView.widthAnchor.constraint(
                    equalToConstant: widthView
                ).isActive = true
            }
        }
    }
}

// MARK: - SetConstraint
extension DetailImageViewController {

    private func setConstraint() {
        NSLayoutConstraint.activate([
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])

        NSLayoutConstraint.activate([
            firstNameLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12),
            firstNameLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8)
        ])

        NSLayoutConstraint.activate([
            lastNameLabel.leftAnchor.constraint(equalTo: firstNameLabel.rightAnchor, constant: 5),
            lastNameLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8)
        ])

        NSLayoutConstraint.activate([
            shareButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
            shareButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -2)
        ])

        NSLayoutConstraint.activate([
            transparentRectangleView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),
            transparentRectangleView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0),
            transparentRectangleView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            transparentRectangleView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -37)
        ])
    }
}
