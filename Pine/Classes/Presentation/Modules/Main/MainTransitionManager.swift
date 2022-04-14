//
//  MainTransitionManager.swift
//  Pine
//
//  Created by Nikita Gavrikov on 12.04.2022.
//

import UIKit

final class MainTransitionManager: NSObject, UIViewControllerAnimatedTransitioning {
    private let operation: UINavigationController.Operation
    private let duration: TimeInterval = 0.3

    init(operation: UINavigationController.Operation) {
        self.operation = operation
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        switch operation {
        case .none:
            return
        case .push:
            animateTransitionForPresent(using: transitionContext)
        case .pop:
            animateTransitionForDismiss(using: transitionContext)
        @unknown default:
            return
        }
    }

    private func animateTransitionForPresent(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromViewController = transitionContext.viewController(forKey: .from) as? MainViewController,
              let toViewController = transitionContext.viewController(forKey: .to) as? DetailImageViewController,
              let cell = fromViewController.selectedCell
        else {
            return
        }

        let containerView = transitionContext.containerView

        let snapShotBackgroundView = UIView()
        snapShotBackgroundView.backgroundColor = .black
        snapShotBackgroundView.frame = containerView.frame
        snapShotBackgroundView.alpha = 0.0

        let snapShotImageView = UIImageView()
        let image = cell.imageView.image
        snapShotImageView.image = image
        snapShotImageView.contentMode = .scaleAspectFit

        let snapShotImageContainerView = UIView()
        snapShotImageContainerView.clipsToBounds = true
        snapShotImageContainerView.frame = cell.convert(cell.imageView.frame, to: fromViewController.view)
        snapShotImageContainerView.addSubview(snapShotImageView)

        let targetFrame = toViewController.view.convert(toViewController.imageView.frame, from: toViewController.view)
        let size = image?.size ?? .zero
        let aspectRatio = size.width / size.height
        let width = targetFrame.width
        let height = width / aspectRatio
        snapShotImageView.frame = .init(
            x: (snapShotImageContainerView.frame.width - width) / 2,
            y: (snapShotImageContainerView.frame.height - height) / 2,
            width: width,
            height: height
        )

        containerView.addSubview(snapShotBackgroundView)
        containerView.addSubview(snapShotImageContainerView)
        containerView.addSubview(toViewController.view)
        cell.isHidden = true

        toViewController.view.isHidden = true
        toViewController.view.setNeedsLayout()
        toViewController.view.layoutIfNeeded()

        UIView.animate(withDuration: duration, animations: {
            snapShotImageContainerView.frame = toViewController.view.convert(toViewController.imageView.frame, from: toViewController.view)
            snapShotImageView.frame = snapShotImageContainerView.bounds
            snapShotBackgroundView.alpha = 1.0
        }, completion: { isFinished in
            snapShotBackgroundView.removeFromSuperview()
            snapShotImageView.removeFromSuperview()
            snapShotImageContainerView.removeFromSuperview()
            toViewController.view.isHidden = false
            transitionContext.completeTransition(isFinished)
        })
    }

    private func animateTransitionForDismiss(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromViewController = transitionContext.viewController(forKey: .from) as? DetailImageViewController,
              let toViewController = transitionContext.viewController(forKey: .to) as? MainViewController,
              let cell = toViewController.selectedCell
        else {
            return
        }

        let containerView = transitionContext.containerView

        let snapShotBackgroundView = UIView()
        snapShotBackgroundView.backgroundColor = .black
        snapShotBackgroundView.frame = containerView.frame
        snapShotBackgroundView.alpha = 1.0

        let snapShotImageView = UIImageView()
        let image = fromViewController.imageView.image
        snapShotImageView.image = image
        snapShotImageView.contentMode = .scaleAspectFit

        let snapShotImageContainerView = UIView()
        snapShotImageContainerView.clipsToBounds = true
        snapShotImageContainerView.addSubview(snapShotImageView)
        snapShotImageContainerView.frame = fromViewController.view.convert(
            fromViewController.imageView.frame,
            from: fromViewController.view
        )
        snapShotImageView.frame = snapShotImageContainerView.bounds

        let targetFrame = toViewController.imagesCollectionView.convert(cell.imageView.frame, to: toViewController.view)
        let size = image?.size ?? .zero
        let aspectRatio = size.width / size.height
        let width = targetFrame.width
        let height = width / aspectRatio

        containerView.addSubview(toViewController.view)
        containerView.addSubview(snapShotBackgroundView)
        containerView.addSubview(snapShotImageContainerView)

        fromViewController.view.isHidden = true

        UIView.animate(withDuration: duration, animations: {
            snapShotImageContainerView.frame = toViewController.imagesCollectionView.convert(cell.frame, to: toViewController.view)
            snapShotImageView.frame = .init(
                x: (snapShotImageContainerView.frame.width - width) / 2,
                y: (snapShotImageContainerView.frame.height - height) / 2,
                width: width,
                height: height
            )
            snapShotBackgroundView.alpha = 0.0
        }, completion: { isFinished in
            snapShotBackgroundView.removeFromSuperview()
            snapShotImageView.removeFromSuperview()
            snapShotImageContainerView.removeFromSuperview()
            cell.isHidden = false
            transitionContext.completeTransition(isFinished)
        })
    }
}

