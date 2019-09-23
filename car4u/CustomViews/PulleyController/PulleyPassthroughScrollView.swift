//
//  PulleyPassthroughScrollView.swift
//  car4u
//
//  Created by Hardik Kothari on 21/9/2562 BE.
//  Copyright © 2562 Hardik Kothari. All rights reserved.
//

import UIKit

protocol PulleyPassthroughScrollViewDelegate: class {
    
    func shouldTouchPassthroughScrollView(scrollView: PulleyPassthroughScrollView, point: CGPoint) -> Bool
    func viewToReceiveTouch(scrollView: PulleyPassthroughScrollView, point: CGPoint) -> UIView
}

class PulleyPassthroughScrollView: UIScrollView {
    
    weak var touchDelegate: PulleyPassthroughScrollViewDelegate?
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        
        if
            let touchDelegate = touchDelegate,
            touchDelegate.shouldTouchPassthroughScrollView(scrollView: self, point: point)
        {
            return touchDelegate.viewToReceiveTouch(scrollView: self, point: point).hitTest(touchDelegate.viewToReceiveTouch(scrollView: self, point: point).convert(point, from: self), with: event)
        }
        
        return super.hitTest(point, with: event)
    }
}
