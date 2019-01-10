//
//  MemeCollectionViewController.swift
//  MemeMeFilipi
//
//  Created by Filipi Brentegani on 07/01/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit

class MemeCollectionViewController: UICollectionViewController {
    
    // MARK: Properties & Variables
    var memes : [Meme]! {
        return (UIApplication.shared.delegate as! AppDelegate).memes
    }
    
    // MARK: IBOutlets
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!

    // MARK: Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let space: CGFloat = 3.0
        let width = (view.frame.size.width - (2 * space)) / 3.0
        let height = (view.frame.size.height - (2 * space)) / 3.0
        
        flowLayout.minimumLineSpacing = space
        flowLayout.minimumInteritemSpacing = space
        flowLayout.itemSize = CGSize(width: width, height: height)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        collectionView?.reloadData()
    }

    // MARK: CollectionView Delegate methods
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCollectionCell", for: indexPath) as? MemeCollectionCell
    
        cell?.collectionCellImageView.image = memes[indexPath.row].memedImage
    
        return cell!
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller: MemeViewController
        controller = storyboard?.instantiateViewController(withIdentifier: "MemeViewController") as! MemeViewController
        
        controller.meme = memes[indexPath.row]
        
        navigationController?.pushViewController(controller, animated: true)
    }

}
