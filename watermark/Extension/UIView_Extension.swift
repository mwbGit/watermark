//
//  UIView.swift
//  watermark
//
//  Created by admin on 2020/9/22.
//  Copyright © 2020 菜鸟教程. All rights reserved.
//

import UIKit

public extension UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    public class func fromNib(nibNameOrNil: String? = nil) -> Self {
            return fromNib(nibNameOrNil, type: self)
        }
        
        public class func fromNib<T : UIView>(nibNameOrNil: String? = nil, type: T.Type) -> T {
            let v: T? = fromNib(nibNameOrNil, type: T.self)
            return v!
        }
        
        public class func fromNib<T : UIView>(nibNameOrNil: String? = nil, type: T.Type) -> T? {
            var view: T?
            let name: String
            if let nibName = nibNameOrNil {
                name = nibName
            } else {
                // Most nibs are demangled by practice, if not, just declare string explicitly
                name = nibName
            }
            let nibViews = NSBundle.mainBundle().loadNibNamed(name, owner: nil, options: nil)
            for v in nibViews {
                if let tog = v as? T {
                    view = tog
                }
            }
            return view
        }
        
        public class var nibName: String {
            let name = "\(self)".componentsSeparatedByString(".").first ?? ""
            return name
        }
        public class var nib: UINib? {
            if let _ = NSBundle.mainBundle().pathForResource(nibName, ofType: "nib") {
                return UINib(nibName: nibName, bundle: nil)
            } else {
                return nil
            }
        }
    }
