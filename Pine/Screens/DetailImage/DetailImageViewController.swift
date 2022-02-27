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

        imageView.image = UIImage(named: "test")
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
        button.setImage(UIImage(named: "icShareWhite"), for: .normal)
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
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.barStyle = .black
    }

    func setViews() {
        view.addSubview(imageView)
        view.addSubview(firstNameLabel)
        view.addSubview(lastNameLabel)
        view.addSubview(transparentRectangleView)
        view.addSubview(shareButton)
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
