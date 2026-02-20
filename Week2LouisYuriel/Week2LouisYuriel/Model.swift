//
//  Model.swift
//  Week2LouisYuriel
//
//  Created by student on 20/02/26.
//

import Foundation

struct Menu{
    let name: String
    let price: Int
}

struct cartItem {
    let restoName: String
    let name: String
    let price: Int
    var quantity : Int
    
}


struct Resto {
    let name: String
    var menus: [Menu]

    func displayMenu(){
        print("Menu di \(self.name)")
        for (index, item) in menus.enumerated(){
            print ("\(index+1). \(item.name). \(item.price)")
        }
        print("[B]ack to menu")
        print("Your Menu Choice")
    }

        
    func getMenuItem(at index: Int)-> Menu?{
        if index >= 0 && index < menus.count{
            return menus[index]
        }
        return nil
    }
}
