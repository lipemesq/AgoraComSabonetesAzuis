//
//  Mesa.swift
//  seraQueOsDeusesNosAbencoarao
//
//  Created by Felipe Mesquita on 24/06/19.
//  Copyright © 2019 Felipe Mesquita. All rights reserved.
//

import UIKit

// Essa é a classe que representa as mesas onde a pessoa dispõe as suas imagens e anotações.
class Mesa {
    
    // As cartas na mesa e as suas respectivas anotações escolhidas
    var conteudo : [(carta: Carta?, config: ControleCartaMesa)] = []
    
    // O tamanho e posição da mesa
    var tamanho : CGSize
    var posicao : CGPoint
    
    // A escala mínima do zoom da mesa
    var escala : CGFloat
    
    // imagem da mesa
    var icone : UIImage!
    
    
    // Inicializa tudo vazio
    init () {
        // carta é um ponteiro, então aponta para NULL, o controle é uma var, então é inicializada com dados inválidos
        //self.conteudo = [ (carta: nil, config: ControleCartaMesa(nota_mostrada: -1)) ]
       
        // TESTE: escala da mesa
//        self.conteudo = [ (carta: Carta(id: "ad", imagem: #imageLiteral(resourceName: "img35.jpg")), config: ControleCartaMesa(nota_mostrada: -1)), (carta: Carta(id: "ad", imagem: #imageLiteral(resourceName: "img35.jpg")), config: ControleCartaMesa(nota_mostrada: -1)), (carta: Carta(id: "ad", imagem: #imageLiteral(resourceName: "img35.jpg")), config: ControleCartaMesa(nota_mostrada: -1)) ]
        
        self.tamanho = .zero
        self.posicao = .zero
        self.escala = 1
    }
    
    
}


// Essa é a classe que carrega as configurações de uma carta na mesa
class ControleCartaMesa {
    
    // Controla o número da anotação sendo mostrada
    var n_nota : Int
    
    // Tamanho e posição da nota na mesa
    var tamanho : CGSize!
    var posicao : CGPoint!
    var z : CGFloat!
    
    var id_mesa : String!
    var id_carta : String!
    
    init (nota_mostrada: Int, id_mesa: String, id_carta: String) {
        self.n_nota = nota_mostrada
        
        // O tamanho depende da escala da mesa
        self.tamanho = .zero
        
        // A posição é sempre constante
        self.posicao = .zero
        self.z = 0
        
        self.id_mesa = id_mesa
        self.id_carta = id_carta
        
    }
    
    
}

extension UIView {
    
    // Using a function since `var image` might conflict with an existing variable
    // (like on `UIImageView`)
    func asImage() -> UIImage {
        if #available(iOS 10.0, *) {
            let renderer = UIGraphicsImageRenderer(bounds: bounds)
            return renderer.image { rendererContext in
                layer.render(in: rendererContext.cgContext)
            }
        } else {
            UIGraphicsBeginImageContext(self.frame.size)
            self.layer.render(in:UIGraphicsGetCurrentContext()!)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return UIImage(cgImage: image!.cgImage!)
        }
    }
}
