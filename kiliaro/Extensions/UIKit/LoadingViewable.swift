//
//  LoadingViewable.swift
//  kiliaro
//
//  Created by Emad Bayramy on 12/7/21.
//

import UIKit

protocol LoadingViewable: AnyObject {
    func animateActivityIndicator()
    func removeActivityIndicator()
}

extension UIView: LoadingViewable {
    
    func animateActivityIndicator() {
        
        let indicatorView = UIActivityIndicatorView()
        indicatorView.style = .large
        
        indicatorView.backgroundColor = UIColor.kiliaroOrange.withAlphaComponent(0.7)
        indicatorView.setCornerRadius(10)
        
        addSubview(indicatorView)
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        
        indicatorView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        indicatorView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        indicatorView.restorationIdentifier = "loadingView"
        
        indicatorView.startAnimating()
    }
    
    func removeActivityIndicator() {
        self.subviews.first(where: {$0.restorationIdentifier == "loadingView"})?.removeFromSuperview()
    }
}

