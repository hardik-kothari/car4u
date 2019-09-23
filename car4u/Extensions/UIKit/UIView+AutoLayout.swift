//
//  UIView+AutoLayout.swift
//  car4u
//
//  Created by Hardik Kothari on 21/9/2562 BE.
//  Copyright © 2562 Hardik Kothari. All rights reserved.
//

import UIKit

extension UIView {
    func autoFitSuperView(edges: UIRectEdge = .all, offset: UIEdgeInsets = .zero) {
        guard let superview = self.superview else {
            return
        }
        autoFit(toView: superview, edges: edges, offset: offset)
    }
    
    func autoCenterSuperView(offset: CGSize = .zero) {
        guard let superview = self.superview else {
            return
        }
        autoCenter(toView: superview, offset: offset)
    }
    
    private func autoCenter(toView view: UIView, offset: CGSize = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        var constraints = [NSLayoutConstraint]()
        constraints.append(centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: offset.width))
        constraints.append(centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: offset.height))
        NSLayoutConstraint.activate(constraints)
    }
    
    private func autoFit(toView view: UIView, edges: UIRectEdge = .all, offset: UIEdgeInsets = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        var constraints = [NSLayoutConstraint]()
        if edges.contains(.top) {
            constraints.append(topAnchor.constraint(equalTo: view.topAnchor, constant: offset.top))
        }
        if edges.contains(.left) {
            constraints.append(leftAnchor.constraint(equalTo: view.leftAnchor, constant: offset.left))
        }
        if edges.contains(.bottom) {
            constraints.append(bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -offset.bottom))
        }
        if edges.contains(.right) {
            constraints.append(rightAnchor.constraint(equalTo: view.rightAnchor, constant: -offset.right))
        }
        NSLayoutConstraint.activate(constraints)
    }
    
    private func constrainToParent() {
        constrainToParent(insets: .zero)
    }
    
    private func constrainToParent(insets: UIEdgeInsets) {
        guard let parent = superview else { return }
        
        translatesAutoresizingMaskIntoConstraints = false
        let metrics: [String : Any] = ["left" : insets.left, "right" : insets.right, "top" : insets.top, "bottom" : insets.bottom]
        
        parent.addConstraints(["H:|-(left)-[view]-(right)-|", "V:|-(top)-[view]-(bottom)-|"].flatMap {
            NSLayoutConstraint.constraints(withVisualFormat: $0, metrics: metrics, views: ["view": self])
        })
    }
}
