//
//  TextViewerViewController.swift
//  AZ CRM
//
//  Created by vmio vmio on 10/14/19.
//  Copyright © 2019 AZCRM. All rights reserved.
//

import UIKit

extension UIAlertController {
    
    /// Add a Text Viewer
    ///
    /// - Parameters:
    ///   - text: text kind
    
    func addTextViewer(text: TextViewerViewController.Kind) {
        let textViewer = TextViewerViewController(text: text)
        set(vc: textViewer)
    }
}

final class TextViewerViewController: UIViewController {
    
    enum Kind {
        
        case text(String?)
        case attributedText([AttributedTextBlock])
    }
    
    fileprivate var text: [AttributedTextBlock] = []
    
    fileprivate lazy var textView: UITextView = {
        $0.isEditable = false
        $0.isSelectable = true
        $0.backgroundColor = nil
        return $0
    }(UITextView())
    
    struct UI {
        static let height: CGFloat = UIScreen.main.bounds.height * 0.8
        static let vInset: CGFloat = 16
        static let hInset: CGFloat = 16
    }
    
    
    init(text kind: Kind) {
        super.init(nibName: nil, bundle: nil)
        
        switch kind {
        case .text(let text):
            textView.text = text
        case .attributedText(let text):
            textView.attributedText = text.map { $0.text }.joined(separator: "\n")
        }
        textView.textContainerInset = UIEdgeInsets(top: UI.hInset, left: UI.vInset, bottom: UI.hInset, right: UI.vInset)
        //preferredContentSize.height = self.textView.contentSize.height
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        Log("has deinitialized")
    }
    
    override func loadView() {
        view = textView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            preferredContentSize.width = UIScreen.main.bounds.width * 0.618
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textView.scrollToTop()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        preferredContentSize.height = textView.contentSize.height
        
    }
}

public extension UITextView {
    
    /// Scroll to the bottom of text view
    public func scrollToBottom() {
        let range = NSMakeRange((text as NSString).length - 1, 1)
        scrollRangeToVisible(range)
    }
    
    /// Scroll to the top of text view
    public func scrollToTop() {
        let range = NSMakeRange(0, 1)
        scrollRangeToVisible(range)
    }
}

extension Array where Element: NSAttributedString {
    func joined(separator: NSAttributedString) -> NSAttributedString {
        var isFirst = true
        return self.reduce(NSMutableAttributedString()) {
            (r, e) in
            if isFirst {
                isFirst = false
            } else {
                r.append(separator)
            }
            r.append(e)
            return r
        }
    }
    
    func joined(separator: String) -> NSAttributedString {
        return joined(separator: NSAttributedString(string: separator))
    }
}
