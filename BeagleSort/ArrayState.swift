//
//  ArrayState.swift
//  BeagleSort
//
//  Created by Pedro Villezca on 10/13/19.
//  Copyright © 2019 WichoInc. All rights reserved.
//

import UIKit

class ArrayState: NSObject {
    public var array : [Int]!
    
    init (array: [Int]!) {
        self.array = array
    }
    
    func compareWith(other: ArrayState) -> Bool {
        for i in 0...self.array.count-1 {
            if (self.array[i] != other.array[i]) {
                return false
            }
        }
        return true
    }
}
