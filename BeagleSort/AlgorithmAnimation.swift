//
//  AlgorithmAnimation.swift
//  BeagleSort
//
//  Created by Hector Díaz Aceves on 11/10/19.
//  Copyright © 2019 WichoInc. All rights reserved.
//

import UIKit

class Transition: NSObject {
    public var fromIndex: Int!
    public var toIndex: Int!
    public var fromValue: Int!
    public var toValue: Int!
    
    init(from: Int, to: Int, fromValue: Int, toValue: Int) {
        self.fromIndex = from
        self.toIndex = to
        self.fromValue = fromValue
        self.toValue = toValue
    }
}

class AlgorithmAnimation: NSObject {
    
    public var algorithm: Algorithm!
    public var array: [Int]!
    public var transitions: [Transition]!
    
    init(algorithm: Algorithm, array: [Int]) {
        super.init()
        self.algorithm = algorithm
        self.array = array
        calculateTransitions()
    }
    
    func calculateTransitions() {
        let algorithmName = algorithm.name
        switch(algorithmName) {
        case "BubbleSort":
            initBubbleSortTransitions()
        case .none:
            print("What")
        case .some(_):
            print("What")
        }
    }
    
    func initBubbleSortTransitions() {
        transitions = []
        let n = array.count
        var i = n - 1
        while (i >= 1){
            for j in 0...i-1{
                if array[j] > array[j+1] {
                    let transition = Transition(from: j, to: j+1, fromValue: array[j], toValue: array[j+1])
                    transitions.append(transition)
                    let temp = array[j]
                    array[j] = array[j+1]
                    array[j+1] = temp
                }
            }
            i = i - 1
        }
    }
    
    func printTransitions() {
        for t in transitions {
            print("Swapping indices \(t.fromIndex) and \(t.toIndex)")
        }
    }
    
}
