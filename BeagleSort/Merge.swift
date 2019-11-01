//
//  Merge.swift
//  BeagleSort
//
//  Created by Hector Díaz Aceves on 01/11/19.
//  Copyright © 2019 WichoInc. All rights reserved.
//

import UIKit

class Merge: AlgorithmStep {
    
    public var start: Int!
    public var middle: Int!
    public var end: Int!
    
    init(start: Int, middle: Int, end: Int) {
        self.start = start
        self.middle = middle
        self.end = end
    }
}
