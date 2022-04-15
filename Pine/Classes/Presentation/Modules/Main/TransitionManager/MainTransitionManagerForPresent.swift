//
//  MainTransitionManagerForPresent.swift
//  Pine
//
//  Created by Nikita Gavrikov on 15.04.2022.
//

import UIKit

final class MainTransitionManagerForPresent: NSObject, UIViewControllerAnimatedTransitioning {
    private let duration: TimeInterval = 0.3
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromViewController = transitionContext.viewController(forKey: .from) as? MainViewController,
              let toViewController = transitionContext.viewController(forKey: .to) as? DetailImageViewController,
              let cell = fromViewController.selectedCell
        else {
            return
        }
        let transitionManagerContext = MainTransitionManagerContext(typeTransition: .present,
                                                                    mainViewController: fromViewController,
                                                                    detailImageViewController: toViewController,
                                                                    cell: cell,
                                                                    transitionContext: transitionContext)
        
        let containerView = transitionContext.containerView
        let snapShotBackgroundView = transitionManagerContext.snapShotBackgroundView
        let snapShotImageView = transitionManagerContext.snapShotImageView
        let snapShotImageContainerView = transitionManagerContext.snapShotImageContainerView
        
        snapShotImageContainerView.addSubview(snapShotImageView)
        containerView.addSubview(snapShotBackgroundView)
        containerView.addSubview(snapShotImageContainerView)
        containerView.addSubview(toViewController.view)
        
        cell.isHidden = true
        toViewController.view.isHidden = true
        toViewController.view.setNeedsLayout()
        toViewController.view.layoutIfNeeded()
        
        UIView.animate(withDuration: duration, animations: {
            snapShotImageContainerView.frame = transitionManagerContext.previewSnapshotFrame()
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
}
