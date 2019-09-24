//
//  ext_Pdata_notas.swift
//  seraQueOsDeusesNosAbencoarao
//
//  Created by Felipe Mesquita on 01/07/19.
//  Copyright © 2019 Felipe Mesquita. All rights reserved.
//

import UIKit
import CoreData

extension vc_detalhesCarta {
    
    /*
    // Salvar uma nota
    func salvar_nota (texto: String, carta: Pdata_carta!) {
        
        // Pega o app delegate. Por que precisa?
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        // pega o contexto
        let context = appDelegate.persistentContainer.viewContext
        
        // Cria a nova entidade
        let nova_nota = Pdata_nota(context: context)
        nova_nota.texto = texto
        nova_nota.carta = carta
        
        carta.addToNotas(nova_nota)
        
        // salva o contexto (commit)
        do {
            try context.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    
    // Atualiza uma nota
    func deletar_nota (nota: Pdata_nota!) {
        
        // Pega o app delegate. Por que precisa?
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        // pega o contexto
        let context = appDelegate.persistentContainer.viewContext
        
        // atualiza a entidade
        context.delete(nota)
        
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
 */

}
