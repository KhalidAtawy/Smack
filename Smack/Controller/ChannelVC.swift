//
//  ChannelVC.swift
//  Smack
//
//  Created by Khalid Saleh Elatawy on 7/6/19.
//  Copyright © 2019 Khalid Saleh Elatawy. All rights reserved.
//

import UIKit

class ChannelVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.revealViewController()?.rearViewRevealWidth = self.view.frame.size.width - 60
    }
    



}
