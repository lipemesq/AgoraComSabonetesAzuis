//
//  vc_escolherImagem.swift
//  seraQueOsDeusesNosAbencoarao
//
//  Created by Felipe Mesquita on 29/06/19.
//  Copyright © 2019 Felipe Mesquita. All rights reserved.
//

import UIKit

// id das celulas
private let id_cel_imagem = "id_celulaPegarImagem"

class vc_escolherImagem: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    // Data
    var ctrl_dados = ControleDeDados.controle
    
    // A collection
    @IBOutlet weak var collectionView: UICollectionView!
    
    // A "navigation" bar
    @IBOutlet weak var barra: UINavigationBar!
    

    // Se escolher uma carta ou cancelou
    var escolheu = false
    var cartaEscolhida : Carta!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
    
        //let collectionViewLayout = collectionView.layout
        // Layout da collection
        
        let margens_laterais : CGFloat = 4
        let margens_verticais : CGFloat = 4
        let tamanho_item = (collectionView.frame.width - (7*margens_laterais)) / 3 // TEM QUE LEVAR EM CONTA AS CONTRAINTS TAMBÉM
        let layout = UICollectionViewFlowLayout.init() //collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsets.init(top: margens_verticais, left: margens_laterais, bottom: margens_verticais, right: margens_laterais)
        layout.itemSize = CGSize(width: tamanho_item, height: tamanho_item * 1.5) // FUTURO: fazer as celulas terem tamanho diferente e ir encaixando
        collectionView.collectionViewLayout = layout

    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        escolheu = false
        
    }
    
    
    // Caso tenha vindo para adicionar uma imagem, avisa a mesa da atitude da criatura
    @objc
    @IBAction func devolveImagem () {
        
        if let tabBar = presentingViewController as? UITabBarController {
            //mesa.escolheu = self.escolheu
            //mesa.cartaEscolhida = self.cartaEscolhida
            //print("mesa : \(mesa.mesa.conteudo[0].carta!.id)")
            let homeNavigationViewController = tabBar.viewControllers![1] as? UINavigationController
            let homeViewController = homeNavigationViewController?.topViewController as! vc_mesa
            homeViewController.escolheu = self.escolheu
            homeViewController.cartaEscolhida = self.cartaEscolhida
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //veioAdd = false
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
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // Numero de seções
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Número de celulas
        return ctrl_dados.num_cartas
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Pega a célula
        let celula = collectionView.dequeueReusableCell(withReuseIdentifier: id_cel_imagem, for: indexPath) as! cel_escolherImagem
        
        // Configura a celula
        celula.carta = ctrl_dados.cartas[indexPath.row]
        celula.img_imagem.image = celula.carta.imagem // TESTAR: usar o viewWillAppear da celula
        
        return celula
    }
    
    // MARK: UICollectionViewDelegate
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let celula = collectionView.cellForItem(at: indexPath) as! cel_escolherImagem
        
        escolheu = true
        cartaEscolhida = celula.carta
        devolveImagem()
        
    }


}
