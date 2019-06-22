//
//  vc_galeriaImagens.swift
//  seraQueOsDeusesNosAbencoarao
//
//  Created by Felipe Mesquita on 12/06/19.
//  Copyright © 2019 Felipe Mesquita. All rights reserved.
//

import UIKit

// id das celulas
private let id_cel_imagem = "id_imagem"

// id das telas
private let id_vc_detalhes = "id_detalhes"

class vc_galeriaImagens: UICollectionViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    // O controle com as cartas
    var ctrl_dados : ControleDeDados!
    
    // Controla se está ou não selecionando
    @IBOutlet weak var btn_botao_esquerdo: UIBarButtonItem!
    var selecionando : Bool = false
    var cartas_selecionadas = [Carta] ()
    // Vou tentar fazer um hash disso
    var hash_selecionadas : [Bool] = [false]
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes // TESTAR: isso aqui é pra n ter que castar o tipo toda vez, não é?
        //self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: id_cel_imagem)

        // Carrega as cartas da criatura
        ctrl_dados = ControleDeDados()
        ctrl_dados.carregarCartas()
        
        // Zera o hash de selecionados
        limpaSelecionadas()
        
        // Layout da collection
        let margens_laterais : CGFloat = 6
        let margens_verticais : CGFloat = 6
        let tamanho_item = (collectionView.frame.width - (4*margens_laterais)) / 2 // TEM QUE LEVAR EM CONTA AS CONTRAINTS TAMBÉM
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsets.init(top: margens_verticais, left: margens_laterais, bottom: margens_verticais, right: margens_laterais)
        layout.itemSize = CGSize(width: tamanho_item, height: tamanho_item * 1.5) // FUTURO: fazer as celulas terem tamanho diferente e ir encaixando
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        selecionando = false
        // Zera o hash de selecionados
        cancelaSelecionadas()
        limpaSelecionadas()
        atualizaBotoes()
    }
    
    
    // Deixa o usuario pegar uma foto da galeria
    // Precisa dar permissão em info.plist
    func imagemDaGaleria () {
        let imagem = UIImagePickerController()
        imagem.delegate = self
        
        imagem.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagem.allowsEditing = false
        print("VAI GALERIA!")
        self.present(imagem, animated: true) {
            // Completion
        }
    }
    
    
    // Controlador para pegar imagens da galeria. É chamada automaticamente.
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let imagem = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            print("DEU CERRTO< ADDENDO")
            ctrl_dados.cartas.append(Carta(id: "um_ID", imagem: imagem))
            self.collectionView.reloadData()
        }
        else {
            // Print Error, invalid format
            print("Formato zoouy")
        }
        
        self.dismiss(animated: true, completion: nil) // No completion?
    }
    
    
    // Remove tudo e depois vai acrescentando
    func limpaSelecionadas () {
        hash_selecionadas.removeAll()
        for _ in 0 ... ctrl_dados.num_cartas-1 {
            hash_selecionadas.append(false)
        }
    }
    
    
    // remove todo mundo que ta selecionado, começando de tras pra frente pra não dar erro
    func removeSelecionadas () {
        for i in (0 ... hash_selecionadas.count-1).reversed() {
            if (hash_selecionadas[i]) {
                ctrl_dados.cartas.remove(at: i)
                collectionView.deleteItems(at: [IndexPath(row: i, section: 0)])
            }
        }
    }
    
    
    // O que muda na celula quando ela está selecionada
    func selecionaCelula (celula : cel_imagemGaleria!) {
        celula.img_imagem.backgroundColor = .black
    }
    
    
    // Como a celula fica quando não está selecionada
    func deselecionaCelula (celula : cel_imagemGaleria!) {
        celula.img_imagem.backgroundColor = .clear
    }
    
    
    // Volta todo mundo pro estado normal
    func cancelaSelecionadas () {
        if (ctrl_dados.cartas.count > 0) {
            for i in 0 ... ctrl_dados.cartas.count-1 {
                if let celula = collectionView.cellForItem(at: IndexPath(item: i, section: 0)) as? cel_imagemGaleria {
                    deselecionaCelula(celula: celula)
                }
            }
        }
    }
    
    
    // Muda os icones dos botoes da navigation bar
    func atualizaBotoes () {
        if (selecionando) {   // Agora está selecionando. O que você deve ver quando estiver selecionando?
            btn_botao_esquerdo.title = "Cancelar"
            self.navigationItem.rightBarButtonItem? = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(botaoDireito)) //UIBarButtonItem.SystemItem.trash
        }
        else {   // Agora não está selecionano. Quanis suas opções de ação?
            btn_botao_esquerdo.title = "Selecionar"
            for i in 0 ... hash_selecionadas.count-1 { // Tudo que estava selecionado
                hash_selecionadas[i] = false
            }
            self.navigationItem.rightBarButtonItem? = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(botaoDireito)) //UIBarButtonItem.SystemItem.trash
            cancelaSelecionadas()   // Tira as cores de quem tava selecionado
        }
    }
    
    
    // Botao da direita
    @objc // pra usar no selector
    func botaoDireito () {
        if (selecionando) {   // Remover
            /*
             remove das cartas quem está selecionado,
             reinicia o hash com false e o tamanho certo (n é muito otimizado)
             deixa de selecionar automaticamente
             atualiza o icone dos botoes
             */
            removeSelecionadas()
            limpaSelecionadas()
            selecionando = false
            atualizaBotoes()
        }
        else {   // Adicionar carta
            imagemDaGaleria()
        }
    }
    
    
    // Selecionar/Cancelar
    @IBAction func botaoEsquerdo(_ sender: UIBarButtonItem) {
        selecionando = !selecionando
        atualizaBotoes()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // Numero de seções
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Número de celulas
        return ctrl_dados.num_cartas
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Pega a célula
        let celula = collectionView.dequeueReusableCell(withReuseIdentifier: id_cel_imagem, for: indexPath) as! cel_imagemGaleria
    
        // Configura a celula
        celula.carta = ctrl_dados.cartas[indexPath.row]
        celula.img_imagem.image = celula.carta.imagem // TESTAR: usar o viewWillAppear da celula
        
        // Se a celula estiver selecionada
        if (selecionando) {
            if (hash_selecionadas[indexPath.row]) {
                selecionaCelula(celula: celula)
            }
            else {
                deselecionaCelula(celula: celula)
            }
        }
        else {   // Se não estiver selecionando
            deselecionaCelula(celula: celula)
        }
    
        return celula
    }

    // MARK: UICollectionViewDelegate
    
    // Movendo a célula
    override func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return !selecionando
    }
    
    override func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        ctrl_dados.cartas.insert(ctrl_dados.cartas.remove(at: sourceIndexPath.row), at: destinationIndexPath.row)
    }

    /*
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }*/
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let celula = collectionView.cellForItem(at: indexPath) as! cel_imagemGaleria
        
        if (selecionando) {   // Se está selecionando
            hash_selecionadas[indexPath.row] = !hash_selecionadas[indexPath.row]
            if (hash_selecionadas[indexPath.row]) {
                selecionaCelula(celula: celula)
            }
            else {
                deselecionaCelula(celula: celula)
            }
        }
        else {   // Caso não esteja selecionando
            if let vc = storyboard?.instantiateViewController(withIdentifier: id_vc_detalhes) as? vc_detalhesCarta {
                vc.carta = celula.carta // troquei da carta do controle para a carta da celula
                self.navigationController?.show(vc, sender: self)
            }
        }
    }


    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }*/
    

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
