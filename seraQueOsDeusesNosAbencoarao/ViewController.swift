//
//  ViewController.swift
//  seraQueOsDeusesNosAbencoarao
//
//  Created by Felipe Mesquita on 07/06/19.
//  Copyright © 2019 Felipe Mesquita. All rights reserved.
//
import Hero
import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var blackView: UIView!
    
    @IBOutlet weak var redView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        redView.hero.id = "ironMan"
        blackView.hero.id = "batMan"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        

    }


} 

