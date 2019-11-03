//
//  AlgorithmAnimation.swift
//  BeagleSort
//
//  Created by Hector Díaz Aceves on 11/10/19.
//  Copyright © 2019 WichoInc. All rights reserved.
//

import UIKit


class AlgorithmAnimation: NSObject {
    
    public var algorithm: Algorithm!
    public var array: [Int]!
    public var steps: [AlgorithmStep]!
    
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
        steps = []
        let n = array.count
        var i = n - 1
        while (i >= 1){
            for j in 0...i-1{
                let comparison = Comparison(indexA: j, indexB: j + 1, valueA: array[j], valueB: array[j+1], sign: ">")
                steps.append(comparison)
                if array[j] > array[j+1] {
                    let transition = Transition(from: j, to: j+1, fromValue: array[j], toValue: array[j+1])
                    steps.append(transition)
                    let temp = array[j]
                    array[j] = array[j+1]
                    array[j+1] = temp
                }
            }
            i = i - 1
        }
    }
    
    
    func initInsertionSortTransitions() {
        /*
        [2,5,3,7,9,4]
         n = 6
         curr = 1
         c = 0
         
         
         curr = 2
         c = 1
         
         PUEDE QUE ESTE MAL ESTO LOLZ
        */
        var curr = 1
        let n = array.count
        while(curr < n) {
            var c = curr-1
            while(c >= 0 && array[c] > array[c+1]){
                //swap
                let temp = array[c+1]
                array[c+1] = array[c]
                array[c] = temp
                c -= 1
            }
            curr += 1
        }
    }
    
    
    func merge(start: Int, middle: Int, end: Int) {
        
        var mergeSteps: [AlgorithmStep] = []
        /*

         TAMBIEN PUEDE QUE ESTE MAL, NO PROBADO
         */
        
        var arrA: [Int] = []
        var arrB: [Int] = []
        
        //Constructing array A from start to middle
        
        var i = start
        while(i <= middle) {
            arrA.append(array[i])
            i += 1
        }
        //Constructing array B from middle + 1 to end
        i = middle + 1
        while(i <= end){
            arrB.append(array[i])
            i += 1
        }
        //Constructing new array from both
        var currA = 0
        var currB = 0
        var curr = start
        
        while(currA < arrA.count && currB < arrB.count) {
            let comparison = Comparison(indexA: currA + start, indexB: currB + middle + 1, valueA: arrA[currA], valueB: arrB[currB], sign: "<")
            var insertion: Insertion
            if (arrA[currA] < arrB[currB]){
                array[curr] = arrA[currA]
                insertion = Insertion(fromIndex: currA + start, toIndex: curr)
                currA += 1
            } else {
                array[curr] = arrB[currB]
                insertion = Insertion(fromIndex: currB + middle + 1, toIndex: curr)
                currB += 1
            }
            mergeSteps.append(comparison)
            mergeSteps.append(insertion)
            curr += 1
        }
        
        while(currA < arrA.count){
            array[curr] = arrA[currA]
            let insertion = Insertion(fromIndex: currA+start, toIndex: curr)
            mergeSteps.append(insertion)
            currA += 1
            curr += 1
        }
        
        while(currB < arrB.count){
            array[curr] = arrB[currB]
            let insertion = Insertion(fromIndex: currB+middle+1, toIndex: curr)
            mergeSteps.append(insertion)
            currB += 1
            curr += 1
        }
        let merge = Merge(start: start, middle: (start+end)/2, end: end, steps: mergeSteps)
        steps.append(merge)
    }
    
    func MergeSort(startIndex: Int, endIndex: Int){
        if (startIndex < endIndex){
            let middle = (startIndex + endIndex) / 2
            MergeSort(startIndex: startIndex, endIndex: middle)
            MergeSort(startIndex: middle+1, endIndex: endIndex)
            merge(start: startIndex, middle: middle, end: endIndex)
        }
    }
    
    
    
    
    func printTransitions() {
        for step in steps {
            if let transition = step as? Transition {
                print("Swapping indices \(transition.fromIndex) and \(transition.toIndex)")
            }
        }
    }
    
}
