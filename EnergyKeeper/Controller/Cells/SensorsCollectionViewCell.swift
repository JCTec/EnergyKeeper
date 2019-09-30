//
//  SensorsCollectionViewCell.swift
//  EnergyKeeper
//
//  Created by Juan Carlos Estevez on 9/26/19.
//  Copyright © 2019 Juan Carlos Estevez. All rights reserved.
//

import UIKit

protocol SensorsCollectionViewCellDelegate: class {
    func shouldUpdateLayout(indexPath: IndexPath)
}

class SensorsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var forwardImage: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    static var identifier: String = "mainCell"
    
    static var nib: UINib! = {
        return "Sensors".loadNib()!
    }()
    
    weak var delegate: SensorsCollectionViewCellDelegate?
    var indexPath: IndexPath!
    var messures = [PowerMesure]()

    var isExpanded: Bool!{
        didSet{
            collectionView.isHidden = !isExpanded
            
            if isExpanded{
                forwardImage.image = #imageLiteral(resourceName: "down.pdf")
                collectionView.reloadData()
            }else{
                forwardImage.image = #imageLiteral(resourceName: "forward")
            }
        }
    }
    
    var image: UIImage! {
        didSet{
            imageView.image = image
            imageView.clipsToBounds = true
            imageView.layer.cornerRadius = 15.0
            imageView.tintColor = .white
        }
    }
    
    // MARK: - Set up
    override func awakeFromNib() {
        forwardImage.clipsToBounds = true
        forwardImage.tintColor = .black
        
        collectionView.register(SensorIndividualCollectionViewCell.nib, forCellWithReuseIdentifier: SensorIndividualCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        //To set expanding only by clicking the arrow turn this on
        /*let tap = UITapGestureRecognizer(target: self, action: #selector(didTapPicture))
         
         forwardImage.isUserInteractionEnabled = true
         forwardImage.addGestureRecognizer(tap)*/
    }
    
    //To set expanding only by clicking the arrow turn this on
    /*@objc func didTapPicture(){
        switchState()
    }*/
    
    func switchState(){
        delegate?.shouldUpdateLayout(indexPath: self.indexPath)
    }
}

// MARK: - UICollectionViewDataSource
extension SensorsCollectionViewCell: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messures.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SensorIndividualCollectionViewCell.identifier, for: indexPath) as! SensorIndividualCollectionViewCell
        
        cell.powerMessure = messures[indexPath.row]
        
        return cell
    }
    
    
}

// MARK: - UICollectionViewDelegateFlowLayout
extension SensorsCollectionViewCell: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 230)
    }
    
}

// MARK: - UICollectionViewDelegate
extension SensorsCollectionViewCell: UICollectionViewDelegate{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
}
