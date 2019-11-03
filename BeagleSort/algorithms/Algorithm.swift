//
//  Algorithm.swift
//  BeagleSort
//
//  Created by César Barraza on 10/10/19.
//  Copyright © 2019 WichoInc. All rights reserved.
//

import UIKit

class Algorithm: NSObject {
    public var name: String!;
    public var image: UIImage!;
    public var averageCase: String!;
    public var worstCase: String!;
    public var spaceComplexity: String!;
    public var implementation: String!;
    
    init(name: String, image: UIImage) {
        self.name = name;
        self.image = image;
    }
}
