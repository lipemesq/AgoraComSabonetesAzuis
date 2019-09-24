//
//  pv_scrollView.swift
//  seraQueOsDeusesNosAbencoarao
//
//  Created by Felipe Mesquita on 27/06/19.
//  Copyright © 2019 Felipe Mesquita. All rights reserved.
//

import UIKit

class pv_scrollView: UIScrollView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override func touchesShouldCancel(in view: UIView) -> Bool {
        if view.tag == 0 {
            return false
        }
        else {
            return false
        }
    }

}
