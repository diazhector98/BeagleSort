//
//  SelectionSort.swift
//  BeagleSort
//
//  Created by Hector Díaz Aceves on 14/11/19.
//  Copyright © 2019 WichoInc. All rights reserved.
//

import Foundation

import UIKit

class SelectionSort {
    public static var instance: Algorithm!;
    
    public static func create() -> Void {
        instance = Algorithm(name: "SelectionSort", image: UIImage(named: "selection-icon")!);
        instance.averageCase = "O(n ^ 2)";
        instance.worstCase = "O(n ^ 2)";
        instance.spaceComplexity = "O(1)";
        instance.implementation =
        """
        for(i = 0; i < n-1 ; i++)  {
            minimum = i ;
            for(j = i+1; j < n ; j++ ) {
                if(arr[ j ] < arr[ minimum ]){
                    minimum = j ;
                }
            }
            swap ( arr[ minimum ], arr[ i ]) ;
        }
        """;
    }
}
