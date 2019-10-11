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
}
