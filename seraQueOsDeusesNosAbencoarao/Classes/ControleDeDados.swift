//
//  ControleDeDados.swift
//  seraQueOsDeusesNosAbencoarao
//
//  Created by Felipe Mesquita on 12/06/19.
//  Copyright © 2019 Felipe Mesquita. All rights reserved.
//

import UIKit
import CoreData

class ControleDeDados {
    
    // Cartas e notas
    var imagens_salvas : [NSObject] = []
    var notas_salvas : [NSObject] = []
    
    // TESTE: mesas
    var mesas_salvas : [NSObject] = []
    var cartas_salvas : [NSObject] = []
    
    //Agora vai ser um singleton
    static let controle = ControleDeDados ()
    
    // Cartas do usuário
    var cartas = [Carta] ()
    
    // Mesas do usuário
    var mesas = [Mesa] ()
    
    // Vetor de cores para as notas
    var cores_notas = [UIColor(named: "C1"), UIColor(named: "C2"), UIColor(named: "C3"), UIColor(named: "C4"), UIColor(named: "C5"), UIColor(named: "C6"), UIColor(named: "C7") ]
    
    
    // Privatiza o init pra ngm mais chamar
    private init () {
        // Carrega as cartas da criatura
        carregarCartas()
    }
    
    
    // Devolve o número de cartas
    var num_cartas : Int {
        get {
            return cartas.count
        }
    }
    
    
    
    // Carrega as cartas
    func carregarCartas () {
        
        //cartas.append(Carta(id: "unica1", imagem: #imageLiteral(resourceName: "img35.jpg")))
        
        /*cartas[0].notas.append(Nota(id: "idn01", texto: """
                                                            FRASEEEEE 1a
                                                            nashdashdohsasfjsf
                                                            linha 3
                                                        """, cor: .red))
        */
        /*
        cartas.append(Carta(id: "unica2", imagem: #imageLiteral(resourceName: "img40.jpg")))
        cartas[1].notas.append(Nota(id: "idn11", texto: "FRASEEEEE 2", cor: .blue))

        cartas.append(Carta(id: "unica3", imagem: #imageLiteral(resourceName: "img47.jpg")))
        cartas[2].notas.append(Nota(id: "idn21", texto: "FRASEEEEE 3", cor: .green))

        cartas.append(Carta(id: "unica4", imagem: #imageLiteral(resourceName: "img48.jpg")))
        cartas[3].notas.append(Nota(id: "idn31", texto: "FRASEEEEE 4", cor: .yellow))

        cartas.append(Carta(id: "unica4", imagem: #imageLiteral(resourceName: "img48.jpg")))
        cartas.append(Carta(id: "unica4", imagem: #imageLiteral(resourceName: "img48.jpg")))
        cartas.append(Carta(id: "unica4", imagem: #imageLiteral(resourceName: "img48.jpg")))
        cartas.append(Carta(id: "unica4", imagem: #imageLiteral(resourceName: "img48.jpg")))
        cartas.append(Carta(id: "unica4", imagem: #imageLiteral(resourceName: "img48.jpg")))
        cartas.append(Carta(id: "unica4", imagem: #imageLiteral(resourceName: "img48.jpg")))
        cartas.append(Carta(id: "unica4", imagem: #imageLiteral(resourceName: "img48.jpg")))
        cartas.append(Carta(id: "unica4", imagem: #imageLiteral(resourceName: "img48.jpg")))
        cartas.append(Carta(id: "unica4", imagem: #imageLiteral(resourceName: "img48.jpg")))
        cartas.append(Carta(id: "unica4", imagem: #imageLiteral(resourceName: "img48.jpg")))
 */
    }
    
    // Salvar uma imagem
    func salvar_nova_imagem (id_imagem: String) {
        
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
        
        carregar_imagens()
    }
    
    
    // Salvar uma nova nota
    func salvar_nova_nota (id_imagem: String, id_nota: String, texto: String, cor: Int) {
        
        // Pega o app delegate. Por que precisa?
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        // pega o contexto
        let context = appDelegate.persistentContainer.viewContext
        
        // Cria a nova entidade
        let nova_nota = Pdata_nota(context: context)
        nova_nota.id_imagem = id_imagem
        nova_nota.id_nota = id_nota
        nova_nota.texto = texto
        nova_nota.cor = Int32(cor)
        
        // salva o contexto (commit)
        do {
            try context.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
        carregar_notas()
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
            self.imagens_salvas = try context.fetch(fetchRequest)
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
            self.notas_salvas = try context.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return false
        }
        
        return true
    }
    
    
    // Excluir uma imagem
    func excluir_imagem_e_notas (id_imagem: String) -> Bool {
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return false
        }
        // Pega o contexto
        let contexto = appDelegate.persistentContainer.viewContext
        
        // Procura a imagem e exclui ela
        for img in (self.imagens_salvas as! [Pdata_carta]) {
            if img.id_imagem == id_imagem {
                contexto.delete(img)
            }
        }
        
        // Procura as notas daquela imagem e exclui também
        for nota in (self.notas_salvas as! [Pdata_nota]) {
            if nota.id_imagem == id_imagem {
                contexto.delete(nota)
            }
        }
        
        // Salva efetivamente
        do {
            try contexto.save()
            return true
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
            return false
        }
        
        carregar_imagens()
        carregar_notas()
        
        atualiza_cartas()
    }
    
    
    // carrega as imagens das cartas
    func atualiza_cartas () {
        self.cartas.removeAll()
        for carta in (self.imagens_salvas as! [Pdata_carta]) {
            if (carta.id_imagem) != nil {
                let imagem_carregada = getSavedImage(named: carta.id_imagem!)
                self.cartas.append(Carta(id: carta.id_imagem!, imagem: imagem_carregada!))
            }
        }
    }
    
    
    // carrega as imagens das cartas
    func atualiza_imagens_mesas () {
        for (i, mesa) in (self.mesas_salvas as! [Pdata_mesa]).enumerated() {
            if (mesa.id_mesa) != nil {
                if let imagem_carregada = getSavedImage(named: mesa.id_mesa!) {
                    mesas[i].icone = imagem_carregada
                    print("carregou")
                }
            }
        }
    }
    
    
    // Atualiza as mesas existentes
    func atualiza_mesas () {
        self.mesas.removeAll()
        for mesa in (self.mesas_salvas as! [Pdata_mesa]) {
            if (mesa.id_mesa) != nil {
                self.mesas.append(Mesa())
            }
        }
    }
    
    
    // Excluir somente uma nota
    func excluir_nota (id_imagem: String, id_nota: String) -> Bool {
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return false
        }
        // Pega o contexto
        let contexto = appDelegate.persistentContainer.viewContext
        
        // Procura as notas daquela imagem e exclui também
        for nota in (self.notas_salvas as! [Pdata_nota]) {
            if nota.id_imagem == id_imagem {
                if nota.id_nota == id_nota {
                    contexto.delete(nota)
                }
            }
        }
        
        // Salva efetivamente
        do {
            try contexto.save()
            return true
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
            return false
        }
        
        carregar_notas()
    }
    
    // Carrega uma única imagem salva
    func getSavedImage(named: String) -> UIImage? {
        if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
            return UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(named).path)
        }
        return nil
    }
    
    
    // TESTE: mesas
    // Carrega o id das imagens salvas
    func carregar_mesas () -> Bool {
        // Pega o app delegate
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return false
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        // Monta a solicitação de busca
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Pdata_mesa")
        
        // Carrega as entidades
        do {
            self.mesas_salvas = try context.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return false
        }
        
        return true
    }
    
    
    // Carrega o id das cartas salvas
    func carregar_cartas () -> Bool {
        // Pega o app delegate
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return false
        }
        let context = appDelegate.persistentContainer.viewContext
        
        // Monta a solicitação de busca
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Pdata_cartaNaMesa")
        
        // Carrega as entidades
        do {
            self.cartas_salvas = try context.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return false
        }
        
        return true
    }
    
    
    // Excluir somente uma mesa
    func excluir_mesa_e_cartas (id_mesa: String) -> Bool {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return false
        }
        // Pega o contexto
        let contexto = appDelegate.persistentContainer.viewContext
        
        // Procura nas mesas e exclui
        for mesa in (self.mesas_salvas as! [Pdata_mesa]) {
            if mesa.id_mesa == id_mesa {
                contexto.delete(mesa)
            }
        }
        
        // Procura as notas daquela imagem e exclui também
        for carta in (self.cartas_salvas as! [Pdata_cartaNaMesa]) {
            if carta.id_mesa == id_mesa {
                contexto.delete(carta)
            }
        }
        
        // Salva efetivamente
        do {
            try contexto.save()
            return true
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
            return false
        }
        
        carregar_mesas()
        carregar_cartas()
    }
    
    // Excluir somente uma carta
    func excluir_carta (id_mesa: String, id_carta: String) -> Bool {
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return false
        }
        // Pega o contexto
        let contexto = appDelegate.persistentContainer.viewContext
        
        // Procura as notas daquela imagem e exclui também
        for carta in (self.cartas_salvas as! [Pdata_cartaNaMesa]) {
            if carta.id_mesa == id_mesa {
                if carta.id_carta == id_carta {
                    contexto.delete(carta)
                }
            }
        }
        
        // Salva efetivamente
        do {
            try contexto.save()
            return true
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
            return false
        }
        
        carregar_cartas()
    }
    
    // Salvar uma nova mesa
    func salvar_nova_mesa (id_mesa: String) {
        
        // Pega o app delegate. Por que precisa?
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        // pega o contexto
        let context = appDelegate.persistentContainer.viewContext
        
        // Cria a nova entidade
        let nova_mesa = Pdata_mesa(context: context)
        nova_mesa.id_mesa = id_mesa
        
        // salva o contexto (commit)
        do {
            try context.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
        carregar_mesas()
    }
    
    // Salvar uma nova mesa
    func salvar_nova_carta (id_mesa: String, id_carta: String) {
        
        // Pega o app delegate. Por que precisa?
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        // pega o contexto
        let context = appDelegate.persistentContainer.viewContext
        
        // Cria a nova entidade
        let nova_carta = Pdata_cartaNaMesa(context: context)
        nova_carta.id_mesa = id_mesa
        nova_carta.id_carta = id_carta
        nova_carta.z = 0
        
        // salva o contexto (commit)
        do {
            try context.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
        carregar_cartas()
    }
    
}
