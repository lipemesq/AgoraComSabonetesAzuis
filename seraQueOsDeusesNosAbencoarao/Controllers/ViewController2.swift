//
//  ViewController2.swift
//  seraQueOsDeusesNosAbencoarao
//
//  Created by Felipe Mesquita on 07/06/19.
//  Copyright © 2019 Felipe Mesquita. All rights reserved.
//

import UIKit

class ViewController2: UIViewController {
    
    @IBOutlet weak var blackView: UIView!
    
    @IBOutlet weak var redView: UIView!
    
    @IBOutlet weak var whiteView: UIView!
    
    @objc func minhaFunc () {
        print("TIROU  PRINT");
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.hero.isEnabled = true
        redView.hero.id = "ironMan"
        blackView.hero.id = "batMan"
        whiteView.hero.modifiers = [.translate(y:whiteView.frame.height)]
        
        NotificationCenter.default.addObserver(self, selector: #selector(minhaFunc), name: UIApplication.userDidTakeScreenshotNotification, object: nil)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    func voltar () {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tocouBotaoVoltar(_ sender: UIButton) {
        voltar()
    }
    
}
