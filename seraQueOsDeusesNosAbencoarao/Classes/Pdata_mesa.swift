//
//  Pdata_mesa.swift
//  seraQueOsDeusesNosAbencoarao
//
//  Created by Felipe Mesquita on 30/06/19.
//  Copyright © 2019 Felipe Mesquita. All rights reserved.
//

import UIKit
import CoreData

public class Pdata_amesa : NSObject {
    let cartas : [String]
    let cpx : [Float]
    let cpy : [Float]
    let ctl : [Float]
    let cta : [Float]
    
    init (cartas: [String], cpx: [Float], cpy: [Float], ctl: [Float], cta: [Float]) {
        self.cartas = cartas
        self.cpx = cpx
        self.cpy = cpy
        self.cta = cta
        self.ctl = ctl
    }
    
}
