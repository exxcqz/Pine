//
//  ImageViewController.swift
//  Pine
//
//  Created by Nikita Gavrikov on 25.02.2022.
//

import UIKit
protocol DetailImageViewInput: class {
    func update(with viewModel: DetailImageViewModel, force: Bool, animated: Bool)
}

protocol DetailImageViewOutput: class {
    func viewDidLoad()
}

final class DetailImageViewController: UIViewController {
    private var viewModel: DetailImageViewModel
    private let output: DetailImageViewOutput

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .black
        return imageView
    }()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .proTextFontMedium(ofSize: 14)
        label.textColor = .white
        return label
    }()

    private lazy var shareButton: UIButton = {
        let button = UIButton()
        button.isHidden = true
        button.setImage(UIImage(named: Icons.icShareWhite), for: .normal)
        button.addTarget(self, action: #selector(openShareController), for: .touchUpInside)
        return button
    }()

    private lazy var transparentRectangleView: UIView = {
        let rectangle = UIView()
        rectangle.backgroundColor = .black
        rectangle.alpha = 0.2
        return rectangle
    }()

    init(viewModel: DetailImageViewModel, output: DetailImageViewOutput) {
        self.viewModel = viewModel
        self.output = output
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewDidLoad()
        setViews()
        changeNavigationBar()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.barStyle = .black
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if viewModel.imageFullScreen {
            imageView.frame = .init(
                x: 0,
                y: view.safeAreaInsets.top,
                width: view.bounds.width,
                height: view.bounds.height - view.safeAreaInsets.top - view.safeAreaInsets.bottom
            )
        } else {
            guard let imageData = viewModel.imageData else { return }
            let scale = view.bounds.width / CGFloat(imageData.width)
            let height = CGFloat(imageData.height) * scale
            imageView.frame = .init(
                x: 0,
                y: 0,
                width: view.bounds.width,
                height: height
            )
            imageView.center = view.center
        }
        transparentRectangleView.frame = .init(
            x: 0,
            y: view.bounds.height - view.safeAreaInsets.bottom - (44 * Layout.scaleFactorW),
            width: view.bounds.width,
            height: 44 * Layout.scaleFactorW
        )
        nameLabel.frame = .init(
            x: 16 * Layout.scaleFactorW,
            y: transparentRectangleView.center.y - (8 * Layout.scaleFactorW),
            width: 315 * Layout.scaleFactorW,
            height: 16 * Layout.scaleFactorW
        )
        shareButton.frame = .init(
            x: 331 * Layout.scaleFactorW,
            y: transparentRectangleView.center.y - (18 * Layout.scaleFactorW),
            width: 36 * Layout.scaleFactorW,
            height: 36 * Layout.scaleFactorW
        )
    }

    private func setViews() {
        view.backgroundColor = .black
        view.addSubview(imageView)
        view.addSubview(transparentRectangleView)
        view.addSubview(nameLabel)
        view.addSubview(shareButton)
    }

    private func changeNavigationBar() {
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: Icons.icBack)
        navigationController?.navigationBar.topItem?.title = ""
        navigationController?.navigationBar.tintColor = .white
    }

    private func setImage() {
        guard let image = viewModel.image else { return }
        self.imageView.image = image
        self.nameLabel.text = viewModel.nameUser
        self.shareButton.isHidden = false
    }

    @objc private func openShareController() {
        guard let image = viewModel.image else { return }
        let shareController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        present(shareController, animated: true, completion: nil)
    }
}

// MARK: - DetailImageViewInput

extension DetailImageViewController: DetailImageViewInput {

    func update(with viewModel: DetailImageViewModel, force: Bool, animated: Bool) {
        self.viewModel = viewModel
        setImage()
        viewDidLayoutSubviews()
    }
}
