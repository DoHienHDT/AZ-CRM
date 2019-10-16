//
//  Shared.swift
//  AZ CRM
//
//  Created by vmio vmio on 10/14/19.
//  Copyright © 2019 AZCRM. All rights reserved.
//


import UIKit

class IndicatorView: UIView {
    var color = UIColor.clear {
        didSet { setNeedsDisplay() }
    }
    
    override func draw(_ rect: CGRect) {
        color.set()
        UIBezierPath(ovalIn: rect).fill()
    }
}

enum ActionDescriptor {
    case read, unread, more, edit, trash, call, xuly
    
    func image(forStyle style: ButtonStyle, displayMode: ButtonDisplayMode) -> UIImage? {
        
        guard displayMode != .titleOnly else { return nil }
        let name: String
        switch self {
        case .read: name = "Read"
        case .unread: name = "read"
        case .more: name = "More"
        case .edit: name = "EditRow"
        case .trash: name = "Trash"
        case .call: name = "phone"
        case .xuly: name = "process"
        }
        return UIImage(named: style == .backgroundColor ? name : name + "-circle")
    }
    
    var color: UIColor {
        switch self {
        case .read, .unread: return #colorLiteral(red: 0, green: 0.4577052593, blue: 1, alpha: 1)
        case .more: return #colorLiteral(red: 0.7803494334, green: 0.7761332393, blue: 0.7967314124, alpha: 1)
        case .edit: return #colorLiteral(red: 0.2734280825, green: 0.2800229192, blue: 0.7113130689, alpha: 1)
        case .trash: return #colorLiteral(red: 0.926926434, green: 0.3141380847, blue: 0.3781706393, alpha: 1)
        case .call: return #colorLiteral(red: 0.926926434, green: 0.3141380847, blue: 0.3781706393, alpha: 1)
        case .xuly: return #colorLiteral(red: 0.3098039329, green: 0.01568627544, blue: 0.1294117719, alpha: 1)
        }
    }
}
enum ButtonDisplayMode {
    case titleAndImage, titleOnly, imageOnly
}

enum ButtonStyle {
    case backgroundColor, circular
}
