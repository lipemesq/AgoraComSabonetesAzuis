//
//  vc_expoPaineis.swift
//  seraQueOsDeusesNosAbencoarao
//
//  Created by Felipe Mesquita on 24/06/19.
//  Copyright © 2019 Felipe Mesquita. All rights reserved.
//

import UIKit
import CoreData

// ID das celulas
private let id_cel_mesa = "id_cel_mesa"

// ID das telas
private let id_vc_mesa = "id_mesa"

class vc_expoPaineis: UICollectionViewController {
    
    // Se está selecionando ou não
    var selecionando = false
    
    // O controle de dados
    var ctrl_dados = ControleDeDados.controle
    
    // Vetor que indica as cartas selecionadas
    var hash_selecionadas : [Bool] = [false]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        //self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.

        // Layout da collection
        let margens_laterais : CGFloat = 6
        let margens_verticais : CGFloat = 6
        let tamanho_item = (collectionView.frame.width - (6*margens_laterais)) / 3 // TEM QUE LEVAR EM CONTA AS CONTRAINTS TAMBÉM
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsets.init(top: margens_verticais, left: margens_laterais, bottom: margens_verticais, right: margens_laterais)
        layout.itemSize = CGSize(width: tamanho_item, height: tamanho_item*1.5) // FUTURO: fazer as celulas terem tamanho diferente e ir encaixando
        
        // Botões da navigation
        //self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Selecionar", style: .plain, target: self, action: #selector(botaoEsquerda))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(botaoDireita))
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        ctrl_dados.carregar_mesas()
        ctrl_dados.carregar_cartas()
        
         /* // Excluir tudo
         for c in (ctrl_dados.mesas_salvas as! [Pdata_mesa]) {
            ctrl_dados.excluir_mesa_e_cartas(id_mesa: c.id_mesa!)
         }*/
 
        ctrl_dados.atualiza_mesas()
        ctrl_dados.atualiza_imagens_mesas()
        
        collectionView.reloadData()
    }
    
    
    // Tocou no botão da esquerda da navigation bar
    @objc
    func botaoEsquerda () {
        selecionando = !selecionando
        
        // Agora como deve estar o botao?
        if (selecionando) {
            self.navigationItem.leftBarButtonItem!.title = "Pronto"
            self.navigationItem.leftBarButtonItem!.style = .done
        }
        else {
            self.navigationItem.leftBarButtonItem!.title = "Selecionar"
            self.navigationItem.leftBarButtonItem!.style = .plain
        }
        
    }
    
    
    func adicionarNota () {
        // Salva uma mesa nova
        let number = Int.random(in: 0 ... 1000000)
        let chave = "Mesa_" + String(number)
        ctrl_dados.salvar_nova_mesa(id_mesa: chave)
        
        // Cria uma nova mesa
        ctrl_dados.mesas.append(Mesa())
        ctrl_dados.mesas[ctrl_dados.mesas.count-1].icone = UIImage()
        
        // Insere na collection com animação
        let ip = IndexPath(item: ctrl_dados.mesas_salvas.count-1/*ctrl_dados.mesas.count-1*/, section: 0)
        collectionView.insertItems(at: [ip])
        
        // Vai para a mesa que acabou de criar
        if let vc = storyboard?.instantiateViewController(withIdentifier: id_vc_mesa) as? vc_mesa {
            print("certissimo")
            vc.mesa = ctrl_dados.mesas[ip.row] //celula.mesa // troquei da carta do controle para a carta da celula
            vc.nMesa = ip.row
            vc.id_mesa = (ctrl_dados.mesas_salvas as! [Pdata_mesa])[ip.row].id_mesa
            self.navigationController?.show(vc, sender: self)
        }
    }
    
    
    // Tocou no botão da direita da navigation bar
    @objc
    func botaoDireita () {
        adicionarNota()
    }
    



}

extension vc_expoPaineis {
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // Número de seções
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Número de itens
        return ctrl_dados.mesas_salvas.count///ctrl_dados.mesas.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let celula = collectionView.dequeueReusableCell(withReuseIdentifier: id_cel_mesa, for: indexPath) as! cel_mesa
        
        let renderer = UIGraphicsImageRenderer(size: view.bounds.size)
        let image = renderer.image { ctx in
            view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        }
        celula.img_icone.image = ctrl_dados.mesas[indexPath.row].icone
        celula.img_icone.contentMode = .scaleAspectFill;
        
        celula.layer.borderWidth = 3
        celula.layer.borderColor = UIColor.lightGray.cgColor
        celula.layer.cornerRadius = 4
        // Não sei fazer a miniatura Configure the cell
        
        return celula
    }
    
    
    // MARK: UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let celula = collectionView.cellForItem(at: indexPath) as! cel_mesa
        
        if (selecionando) {   // Se está selecionando
            hash_selecionadas[indexPath.row] = !hash_selecionadas[indexPath.row]
            if (hash_selecionadas[indexPath.row]) {
                //selecionaCelula(celula: celula)
            }
            else {
                //deselecionaCelula(celula: celula)
            }
        }
        else {   // Caso não esteja selecionando
            print("entrou")
            if let vc = storyboard?.instantiateViewController(withIdentifier: id_vc_mesa) as? vc_mesa {
                print("certissimo")
                vc.mesa = ctrl_dados.mesas[indexPath.row] //celula.mesa // troquei da carta do controle para a carta da celula
                vc.nMesa = indexPath.row
                vc.id_mesa = (ctrl_dados.mesas_salvas as! [Pdata_mesa])[indexPath.row].id_mesa
                self.navigationController?.show(vc, sender: self)
            }
        }
    }
    
}

