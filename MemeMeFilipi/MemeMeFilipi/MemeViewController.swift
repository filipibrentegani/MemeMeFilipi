//
//  MemeViewController.swift
//  MemeMeFilipi
//
//  Created by Filipi Brentegani on 08/01/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit

class MemeViewController: UIViewController {
    
    // MARK: Properties & Variables
    var meme: Meme?
    
    // MARK: IBOutlets
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK: Lifecycle methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        imageView.image = meme?.memedImage
    }
}
