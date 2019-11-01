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
    public var steps: [AlgorithmStep]!
    
    init(start: Int, middle: Int, end: Int, steps: [AlgorithmStep]) {
        self.start = start
        self.middle = middle
        self.end = end
        self.steps = steps
    }
}
