//
//  MainTransitionManagerContext.swift
//  Pine
//
//  Created by Nikita Gavrikov on 15.04.2022.
//

import UIKit

enum TypeTransition {
    case present
    case dismiss
}

final class MainTransitionManagerContext {
    private let typeTransition: TypeTransition
    private var mainViewController: MainViewController
    private var detailImageViewController: DetailImageViewController
    private let cell: MainViewCell
    private let transitionContext: UIViewControllerContextTransitioning
    
    lazy var snapShotBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.frame = transitionContext.containerView.frame
        switch typeTransition {
        case .present:
            view.alpha = 0.0
        case .dismiss:
            view.alpha = 1.0
        }
        return view
    }()
    
    lazy var snapShotImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        switch typeTransition {
        case .present:
            imageView.image = cell.imageView.image
            imageView.frame = cellImageViewFrame()
        case .dismiss:
            imageView.image = detailImageViewController.imageView.image
            imageView.frame = snapShotImageContainerView.bounds
        }
        return imageView
    }()
    
    lazy var snapShotImageContainerView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        switch typeTransition {
        case .present:
            guard let cell = mainViewController.selectedCell else { return view }
            view.frame = cell.convert(cell.imageView.frame, to: mainViewController.view)
        case .dismiss:
            view.frame = detailImageViewController.view.convert(detailImageViewController.imageView.frame,
                                                                from: detailImageViewController.view)
        }
        return view
    }()
    
    init(typeTransition: TypeTransition,
         mainViewController: MainViewController,
         detailImageViewController: DetailImageViewController,
         cell: MainViewCell,
         transitionContext: UIViewControllerContextTransitioning) {
        self.typeTransition = typeTransition
        self.mainViewController = mainViewController
        self.detailImageViewController = detailImageViewController
        self.cell = cell
        self.transitionContext = transitionContext
    }
    
    func cellSnapShotFrame() -> CGRect {
        return mainViewController.imagesCollectionView.convert(cell.frame,
                                                               to: mainViewController.view)
    }
    
    func cellImageViewFrame() -> CGRect {
        let (width, height) = getSnapShotImageViewSize()
        return .init(x: (snapShotImageContainerView.frame.width - width) / 2,
                     y: (snapShotImageContainerView.frame.height - height) / 2,
                     width: width,
                     height: height)
    }
    
    func previewSnapshotFrame() -> CGRect {
        return detailImageViewController.view.convert(detailImageViewController.imageView.frame,
                                                      from: detailImageViewController.view)
    }
    
    private func getSnapShotImageViewSize() -> (width: CGFloat, height: CGFloat) {
        let targetFrame: CGRect
        let size: CGSize
        switch typeTransition {
        case .present:
            targetFrame = detailImageViewController.view.convert(detailImageViewController.imageView.frame,
                                                                 from: detailImageViewController.view)
            size = cell.imageView.image?.size ?? .zero
        case .dismiss:
            targetFrame = mainViewController.imagesCollectionView.convert(cell.imageView.frame,
                                                                          to: mainViewController.view)
            size = detailImageViewController.imageView.image?.size ?? .zero
        }
        let aspectRatio = size.width / size.height
        let width = targetFrame.width
        let height = width / aspectRatio
        return (width, height)
    }
}
