//
//  ext_Pdata.swift
//  seraQueOsDeusesNosAbencoarao
//
//  Created by Felipe Mesquita on 01/07/19.
//  Copyright © 2019 Felipe Mesquita. All rights reserved.
//

import UIKit
import CoreData

extension vc_galeriaImagens {
    
    /*
    // Salvar uma imagem
    func salvar_imagem (id_imagem: String) {
        
        // Pega o app delegate. Por que precisa?
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        // pega o contexto
        let context = appDelegate.persistentContainer.viewContext
        
        // Cria a nova entidade
        let nova_img = Pdata_carta(context: context)
        nova_img.id_imagem = id_imagem
        
        // salva o contexto (commit)
        do {
            try context.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    
    // Carrega o id das imagens salvas
    func carregar_imagens () -> Bool {
        // Pega o app delegate
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
            return false
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        // Monta a solicitação de busca
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Pdata_carta")
        
        // Carrega as entidades
        do {
            ctrl_dados.imagens_salvas = try context.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return false
        }
        
        return true
    }
    
    
    // Carrega as notas das imagens
    func carregar_notas () -> Bool {
        // Pega o app delegate
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return false
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        // Monta a solicitação de busca
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Pdata_nota")
        
        // Carrega as entidades
        do {
            ctrl_dados.notas_salvas = try context.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return false
        }
        
        return true
    }
    
    
    // Procura as imagens e cria as cartas a partir das 'imagens_salvas'
    func cria_cartas () -> Bool {
        
        ctrl_dados.cartas.removeAll()
        if let id_imgs = ctrl_dados.imagens_salvas as? [Pdata_carta] {
            for ids in id_imgs {
                if let id = ids.id_imagem {
                    if let imagem_carregada = getSavedImage(named: id) {
                        let carta = Carta(id: id, imagem: imagem_carregada)
                        
                        // Teste 1 ----- Procura as notas daquela carta
                        if let v_notas = ids.notas?.allObjects {
                            if let notas = v_notas as? [Pdata_nota] {
                                for n in notas {
                                    carta.notas.append(Nota(id: "nota", texto: n.texto!, cor: .lightGray))
                                }
                            }
                        }
                        // Fim teste 1 --------------------
                        
                        ctrl_dados.cartas.append(carta)
                    }
                }
            }
        }
        else {
            return false
        }
        
        return true
    }
    
    
    // Excluir uma imagem
    func excluir_imagem (i: Int) -> Bool {
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return false
        }
        // Pega o contexto
        let contexto = appDelegate.persistentContainer.viewContext
        
        // Pega a nota e atualiza ela
        let img = ctrl_dados.imagens_salvas[i] as! NSManagedObject
        contexto.delete(img)
        
        // Salva efetivamente
        do {
            try contexto.save()
            return true
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
            return false
        }
    }

    */
}
