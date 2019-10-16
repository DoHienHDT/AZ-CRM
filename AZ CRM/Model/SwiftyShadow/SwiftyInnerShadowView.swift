//
//  SwiftyInnerShadowView.swift
//  AZ CRM
//
//  Created by vmio vmio on 10/14/19.
//  Copyright © 2019 AZCRM. All rights reserved.
//


import UIKit

open class SwiftyInnerShadowView: UIView {
    
    open var shadowLayer = SwiftyInnerShadowLayer()
    
    override open var bounds: CGRect {
        didSet {
            shadowLayer.frame = bounds
        }
    }
    
    override open var frame: CGRect {
        didSet {
            shadowLayer.frame = bounds
        }
    }
    
    open var cornerRadius1: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius1
            shadowLayer.cornerRadius = cornerRadius1
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initShadowLayer()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initShadowLayer()
    }
    
    fileprivate func initShadowLayer() {
        layer.addSublayer(shadowLayer)
    }
    
}
