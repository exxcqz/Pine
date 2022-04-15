//
//  MainTransitionManagerForDismiss.swift
//  Pine
//
//  Created by Nikita Gavrikov on 15.04.2022.
//

import UIKit

final class MainTransitionManagerForDismiss: NSObject, UIViewControllerAnimatedTransitioning {
    private let duration: TimeInterval = 0.3

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromViewController = transitionContext.viewController(forKey: .from) as? DetailImageViewController,
              let toViewController = transitionContext.viewController(forKey: .to) as? MainViewController,
              let cell = toViewController.selectedCell
        else {
            return
        }
        let transitionManagerContext = MainTransitionManagerContext(typeTransition: .dismiss,
                                                                    mainViewController: toViewController,
                                                                    detailImageViewController: fromViewController,
                                                                    cell: cell,
                                                                    transitionContext: transitionContext)

        let containerView = transitionContext.containerView
        let snapShotBackgroundView = transitionManagerContext.snapShotBackgroundView
        let snapShotImageView = transitionManagerContext.snapShotImageView
        let snapShotImageContainerView = transitionManagerContext.snapShotImageContainerView

        snapShotImageContainerView.addSubview(snapShotImageView)
        containerView.addSubview(toViewController.view)
        containerView.addSubview(snapShotBackgroundView)
        containerView.addSubview(snapShotImageContainerView)
        fromViewController.view.isHidden = true

        UIView.animate(withDuration: duration, animations: {
            snapShotImageContainerView.frame = transitionManagerContext.cellSnapShotFrame()
            snapShotImageView.frame = transitionManagerContext.cellImageViewFrame()
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
