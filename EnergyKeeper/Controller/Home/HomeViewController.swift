//
//  HomeViewController.swift
//  EnergyKeeper
//
//  Created by Juan Carlos Estevez on 9/25/19.
//  Copyright © 2019 Juan Carlos Estevez. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var mainTitle: UILabel!
    @IBOutlet weak var subTitle: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var alertDisplayer: String = "alertDisplayer"
    private var loginSegue: String = "loginSegue"

    private var isExpanded = [false, true]
    private var allowsExpation = [false, true]
    private let expandedHeight : CGFloat = 550
    private let notExpandedHeight : CGFloat = 51
    
    var info = [Sensor]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        info = [Sensor(image: #imageLiteral(resourceName: "building.pdf"), name: "Edificios", powerMessures: [PowerMesure]()), Sensor(image: #imageLiteral(resourceName: "chip"), name: "Sensores Principales", powerMessures: [PowerMesure(voltage: Double.random(in: 120.0...122.0), current: Double.random(in: 8.0...15.5)), PowerMesure(voltage: Double.random(in: 120.0...122.0), current: Double.random(in: 8.0...15.5))])]
        
        setUp()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        collectionView.reloadData()
    }
    
    private func setUp(){
        navigationController?.setNavigationBarHidden(false, animated: false)
        
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = .white
        
        navigationController?.navigationBar.topItem?.title = "Energy Keeper"
        
        navigationItem.rightBarButtonItems = barButtons()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(SensorsCollectionViewCell.nib, forCellWithReuseIdentifier: SensorsCollectionViewCell.identifier)
        
    }
    
    private func barButtons() -> [UIBarButtonItem]{
        let image = #imageLiteral(resourceName: "Bell").resized(toWidth: 25.0)!.withRenderingMode(.alwaysOriginal)
        
        let bell = UIBarButtonItem(image: image, style: .plain, target: nil, action: nil)
        
        let imageUser = #imageLiteral(resourceName: "User").resized(toWidth: 25.0)!.withRenderingMode(.alwaysOriginal)
        
        let user = UIBarButtonItem(image: imageUser, style: .plain, target: self, action: #selector(userMenu))
        
        return [user, bell]
    }
    
    @objc func userMenu(){
        alertDisplayer.performSegue(on: self)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        if segue.destination is AlertDisplayerViewController{
            let vc = segue.destination as! AlertDisplayerViewController
            
            vc.text = "¿Seguro que desea continuar?"
            vc.titleText = "Cerrar Sessión"
            vc.leftText = "Cancelar"
            vc.rightText = "Ok"
            vc.negative = false
        }
        // Pass the selected object to the new view controller.
    }


}

extension HomeViewController: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return info.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SensorsCollectionViewCell.identifier, for: indexPath) as! SensorsCollectionViewCell
        
        let infoToUse = info[indexPath.row]
        
        cell.image = infoToUse.image
        cell.indexPath = indexPath
        cell.delegate = self
        cell.isExpanded = isExpanded[indexPath.row]
        cell.messures = infoToUse.powerMessures
        
        return cell
    }
    
    //To set expanding only by clicking the arrow turn this off
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if allowsExpation[indexPath.row]{
            let cell = collectionView.cellForItem(at: indexPath) as? SensorsCollectionViewCell
            cell?.switchState()
        }
    }
    
}

extension HomeViewController: UICollectionViewDelegate{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
}

extension HomeViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if isExpanded[indexPath.row]{
            return CGSize(width: collectionView.frame.width, height: expandedHeight)
        }else{
            return CGSize(width: collectionView.frame.width, height: notExpandedHeight)
        }
        
    }
    
}


extension HomeViewController: SensorsCollectionViewCellDelegate{
    
    func shouldUpdateLayout(indexPath: IndexPath) {
        isExpanded[indexPath.row] = !isExpanded[indexPath.row]
        UIView.animate(withDuration: 0.8, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.9, options: UIView.AnimationOptions.curveEaseInOut, animations: {
            self.collectionView.collectionViewLayout.invalidateLayout()
            self.collectionView.reloadItems(at: [indexPath])
        }, completion: nil)
    }
    
}

