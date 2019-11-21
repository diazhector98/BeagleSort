//
//  StylesHelper.swift
//  BeagleSort
//
//  Created by César Barraza on 10/10/19.
//  Copyright © 2019 WichoInc. All rights reserved.
//

import UIKit

class StylesHelper {
    public static func addButtonStyles(button: UIButton!) -> Void {
        button.layer.cornerRadius = 8;
        button.clipsToBounds = true;
        button.layer.shadowColor = UIColor.black.cgColor;
        button.layer.shadowOffset = CGSize(width: 0, height: 2);
        button.layer.shadowRadius = 5;
        button.layer.shadowOpacity = 0.2;
        button.layer.masksToBounds = false;
    }
    
    public static func addViewStyles(view: UIView!) -> Void {
        view.layer.cornerRadius = 10;
        view.clipsToBounds = true;
        view.layer.shadowColor = UIColor.black.cgColor;
        view.layer.shadowOffset = CGSize(width: 0, height: 2);
        view.layer.shadowRadius = 2;
        view.layer.shadowOpacity = 0.2;
        view.layer.masksToBounds = false;
    }
    
    public static func addNodeStyles(node: UIView!) -> Void {
        node.layer.cornerRadius = 4;
        node.clipsToBounds = true;
        node.layer.shadowColor = UIColor.black.cgColor;
        node.layer.shadowOffset = CGSize(width: 0, height: 2);
        node.layer.shadowRadius = 2;
        node.layer.shadowOpacity = 0.2;
        node.layer.masksToBounds = false;
    }
}
