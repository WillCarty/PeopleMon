//
//  TransitionManager.swift
//  Peoplemon
//
//  Created by Will Carty on 11/8/16.
//  Copyright © 2016 Will Carty. All rights reserved.
//

import Foundation
import UIKit

class TransitionManager: NSObject, UIViewControllerAnimatedTransitioning {
    var reverse: Bool = false
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        let toView = toViewController.view
        let fromView = fromViewController.view
        
        let transformedView = reverse ? fromView : toView
        
        let startAlpha: CGFloat = reverse ? 1.0 : 0.0
        let endAlpha: CGFloat = reverse ? 0.0 : 1.0
        let startSize: CGFloat = reverse ? 1.0 : 0.05
        let endSize: CGFloat = reverse ? 0.05 : 1.0
        
        transformedView?.alpha = startAlpha
        transformedView?.transform = CGAffineTransform(scaleX: startSize, y: startSize)
        
        containerView.addSubview(toView!)
        if reverse {
            containerView.sendSubview(toBack: toView!)
        }
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            transformedView?.alpha = endAlpha
            transformedView?.transform = CGAffineTransform(scaleX: endSize, y: endSize)
        }) { (finished) in
            if transitionContext.transitionWasCancelled {
                toView?.removeFromSuperview()
            } else {
                for view in containerView.subviews where view != toView {
                    view.removeFromSuperview()
                }
            }
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}


