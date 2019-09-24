//
//  Nota.swift
//  seraQueOsDeusesNosAbencoarao
//
//  Created by Felipe Mesquita on 12/06/19.
//  Copyright © 2019 Felipe Mesquita. All rights reserved.
//

import UIKit

class Nota {
    
    // Identificador da nota
    var id : String
    
    // Texto da nota
    var texto : String
    
    // Cor da nota
    var cor : Int
    
    init (id : String, texto: String, cor: Int) {
        self.id = id
        self.texto = texto
        self.cor = cor
    }
    
}
