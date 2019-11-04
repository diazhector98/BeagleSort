//
//  UserModel.swift
//  BeagleSort
//
//  Created by César Barraza on 11/2/19.
//  Copyright © 2019 WichoInc. All rights reserved.
//

import UIKit

class UserModel: NSObject {
    public var name: String!;
    public var won: Int!;
    public var lost: Int!;
    
    init(name: String, won: Int, lost: Int) {
        self.name = name;
        self.won = won;
        self.lost = lost;
    }
}
