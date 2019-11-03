//
//  InsertionSort.swift
//  BeagleSort
//
//  Created by Hector Díaz Aceves on 03/11/19.
//  Copyright © 2019 WichoInc. All rights reserved.
//

import Foundation

import UIKit

class InsertionSort {
    public static var instance: Algorithm!;
    
    public static func create() -> Void {
        instance = Algorithm(name: "InsertionSort", image: UIImage(named: "bubble-icon")!);
        instance.averageCase = "O(n ^ 2)";
        instance.worstCase = "O(n ^ 2)";
        instance.spaceComplexity = "O(1)";
        instance.implementation =
        """
        for (i = 0; i < n - 1; i++) {
        flag = false;
        for (j = 0; j < n - i - 1; j++) {
        if (arr[j] > arr[j + 1]) {
        swap(arr[j], arr[j + 1]);
        flag = true;
        }
        }
        
        if (!flag) {
        break;
        }
        }
        """;
    }
}
