//
//  Cond.swift
//  Safety Butler
//
//  Created by Chia-Yu Hsu on 3/11/19.
//  Copyright © 2019 monashUni. All rights reserved.
//

import UIKit

class Cond: NSObject {
    var temp: Double
    var gas: Int
    var flame: Int
    
    init(temp: Double, gas: Int, flame: Int){
        self.temp = temp
        self.gas = gas
        self.flame = flame
    }
    
    func getTemp() -> Double{
        return temp
    }
    
    func getGas() -> Int{
        return gas
    }
    
    func getFlame() -> Int{
        return flame
    }
    
    func setTemp(newTemp: Double) {
        temp = newTemp
    }
    
    func setGas(newGas: Int) {
        gas = newGas
    }
    
    func setFlame(newFlame: Int) {
        flame = newFlame
    }

}
