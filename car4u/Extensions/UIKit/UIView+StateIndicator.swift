//
//  UIView+StateIndicator.swift
//  car4u
//
//  Created by Hardik Kothari on 21/9/2562 BE.
//  Copyright © 2562 Hardik Kothari. All rights reserved.
//

import UIKit

extension UIView {
    enum ViewState {
        case loading
        case error(message: String?, tryAgain:(() -> Void))
        case none
    }
    
    private struct AssociatedKeys {
        static var statusView = "statusView"
    }
    
    private (set) var statusView: UIView? {
        get {
            guard let view = objc_getAssociatedObject(self, &AssociatedKeys.statusView) as? UIView else {
                return nil
            }
            return view
        }
        set {
            statusView?.removeFromSuperview()
            objc_setAssociatedObject(self, &AssociatedKeys.statusView, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func show(_ state: ViewState) {
        self.statusView?.removeFromSuperview()
        self.statusView = nil
        
        var view: UIView?
        switch state {
        case .loading:
            view = getProgressView()
        case .error(let message, let tryAgain):
            view = getErrorView(message: message, tryAgain: tryAgain)
        default:
            break
        }
        if let view = view {
            view.layer.cornerRadius = layer.cornerRadius
            addSubview(view)
            view.autoFitSuperView()
            self.statusView = view
        }
    }
    
    private func getProgressView() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        view.translatesAutoresizingMaskIntoConstraints = false
        let indicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.whiteLarge)
        indicator.color = UIColor(hexString: "#175593")
        indicator.hidesWhenStopped = false
        indicator.startAnimating()
        view.addSubview(indicator)
        indicator.autoCenterSuperView()
        return view
    }
    
    private func getErrorView(message: String?, tryAgain:@escaping (() -> Void)) -> UIView {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 30
        
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = message
        label.textColor = UIColor(hexString: "#175593")
        label.font = UIFont.systemFont(ofSize: 18.0)
        stack.addArrangedSubview(label)
        
        let retryButton = UIButton()
        retryButton.setTitle("Try again", for: UIControl.State.normal)
        retryButton.setTitleColor(.white, for: UIControl.State.normal)
        retryButton.titleLabel?.font =  UIFont.systemFont(ofSize: 16.0, weight: .bold)
        retryButton.backgroundColor = UIColor(hexString: "#175593")
        retryButton.layer.cornerRadius = 24.0
        retryButton.addAction(for: .touchUpInside) { (button) in
            tryAgain()
        }
        stack.addArrangedSubview(retryButton)

        view.addSubview(stack)
        NSLayoutConstraint.activate([
            retryButton.heightAnchor.constraint(equalToConstant: 48.0),
            stack.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 40),
            stack.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -40),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
        return view
    }
}
