//
//  AlertDisplayer.swift
//  AlertDisplayer
//  
//  Created by Juan Carlos Estevez on 5/28/19.
//  Copyright © 2019 Juan Carlos Estevez. All rights reserved.
//

import Foundation
import UIKit

public protocol AlertDisplayerDelegate: class {
    func setExitImage() -> UIImage?
    func setUpButtons()
    
    func mainImageHightMultiplier() -> CGFloat
    func quantyOfExtraSpaceForImage() -> CGFloat

    func setFont(to label: UILabel)
    func setBoldFont(to label: UILabel)
    func didSelectMainImage()
    func alertDisplayerDidLoad()
    func alertDisplayerWillAppear()
    func didPressOk()
    func didPressCancel()
}

public extension AlertDisplayerDelegate{
    
    func mainImageHightMultiplier() -> CGFloat{
        return 1.0
    }
    
    func quantyOfExtraSpaceForImage() -> CGFloat{
        return 120.0
    }
    
    func didSelectMainImage(){
        print("didSelectMainImage")
    }
    
    func alertDisplayerWillAppear(){
        print("alertDisplayerWillAppear")
    }
    
    func setExitImage() -> UIImage?{
        return nil
    }
}

public class AlertDisplayer: UIView{
    
    public var mainColor: UIColor = UIColor.white
    
    public var decorations: UIColor = UIColor(red:0.24, green:0.84, blue:0.44, alpha:1)
    
    public var textColor: UIColor = .black

    public var width: CGFloat = 350.0
    
    public var height: CGFloat = 200.0
    
    public var exitImage: UIImage?
    
    public var buttonHeight: CGFloat = 60.0
    
    public var cornerRadius: CGFloat = 25.0
    
    public var contentView: UIView!
    public var buttonStack: UIStackView!
    public var mainStack: UIStackView!
    public var topView: UIView!
    public var mainImage: UIImageView!
    public var topConstraint: NSLayoutConstraint!
    
    public lazy var leftButton: UIButton! = {
        let button = UIButton()
        button.addTarget(self, action: #selector(self.didSelectLeft), for: .touchUpInside)
        return button
    }()
    
    public lazy var rightButton: UIButton! = {
        let button = UIButton()
        button.addTarget(self, action: #selector(self.didSelectRight), for: .touchUpInside)
        return button
    }()
    
    public var boldLabel: UILabel!
    public var normalLabel: TopAlignedLabel!
    public var normalLabelForUserInterface: UILabel!
    public var imageView: UIImageView!
    
    weak var delegate: AlertDisplayerDelegate!
    
    private var topBorder: UIView!
    private var leftBorder: UIView!
    private var rightBorder: UIView!
    
    private var constraintsToAdd: [NSLayoutConstraint] = [NSLayoutConstraint]()
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
        
    }
    
    private func commonInit(){
        self.contentView = UIView()
        self.topView = UIView()
        self.boldLabel = UILabel()
        self.normalLabel = TopAlignedLabel()
        
        self.layer.masksToBounds = false
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        
        self.buttonStack = UIStackView(arrangedSubviews: [self.leftButton, self.rightButton])
        self.buttonStack.axis = NSLayoutConstraint.Axis.horizontal
        self.buttonStack.distribution = .fillEqually
        self.buttonStack.alignment = .fill
        self.buttonStack.spacing = 0
        self.buttonStack.translatesAutoresizingMaskIntoConstraints = false
        
        self.mainStack = UIStackView(arrangedSubviews: [self.topView, self.buttonStack])
        self.mainStack.axis = NSLayoutConstraint.Axis.vertical
        self.mainStack.spacing = 0
        self.mainStack.translatesAutoresizingMaskIntoConstraints = false
        self.mainStack.layer.cornerRadius = self.cornerRadius
        
        self.contentView.layer.masksToBounds = false
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(self.mainStack)
        self.contentView.backgroundColor = self.mainColor
        self.contentView.layer.cornerRadius = self.cornerRadius
        self.contentView.addSubview(self.mainStack)
        
        self.topView.backgroundColor = UIColor.white.withAlphaComponent(0.0)
        self.topView.translatesAutoresizingMaskIntoConstraints = false
        self.topView.addSubview(self.boldLabel)
        self.topView.addSubview(self.normalLabel)
        
        self.boldLabel.translatesAutoresizingMaskIntoConstraints = false
        self.boldLabel.textAlignment = .center
        self.boldLabel.font = UIFont.systemFont(ofSize: 19.5, weight: .bold)
        
        self.normalLabel.translatesAutoresizingMaskIntoConstraints = false
        self.normalLabel.textAlignment = .center
        self.normalLabel.font = UIFont.systemFont(ofSize: 15)
        
        self.setUpBorders()
        self.setUpButtons("No", "Si")
        
        self.setUpSpace(for: self.boldLabel, "Este es el titulo Bold")
        self.setUpSpace(for: self.normalLabel, "Este es el titulo normal")
        
        self.rightButton.backgroundColor = UIColor.white.withAlphaComponent(0.0)
        self.rightButton.setTitleColor(self.decorations, for: .normal)
        
        self.leftButton.backgroundColor = UIColor.white.withAlphaComponent(0.0)
        self.leftButton.setTitleColor(self.decorations, for: .normal)
        
        self.setUpConstraints()
        
        self.addSubview(self.contentView)
        self.bringSubviewToFront(self.contentView)
        self.contentView.bringSubviewToFront(self.mainStack)
    }
    
    public func configureWith(_ delegate: AlertDisplayerDelegate, _ width: CGFloat? = nil,_ height: CGFloat? = nil, _ image: UIImage? = nil){
        self.delegate = delegate
        self.delegate?.setUpButtons()
        self.delegate?.setBoldFont(to: self.boldLabel)
        self.delegate?.setFont(to: self.normalLabel)
        self.delegate?.alertDisplayerDidLoad()
        
        self.exitImage = self.delegate?.setExitImage()
        
        var heightToUse: CGFloat = height ?? 250
        
        if image != nil{
            
            let quantityOfExtraSpaceForImage: CGFloat = self.delegate?.quantyOfExtraSpaceForImage() ?? 120.0
            
            heightToUse += quantityOfExtraSpaceForImage
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.didSelectImage))
            tap.cancelsTouchesInView = true
            
            self.mainImage = UIImageView(image: image!)
            self.mainImage.clipsToBounds = true
            self.mainImage.translatesAutoresizingMaskIntoConstraints = false
            self.mainImage.contentMode = .scaleAspectFill
            self.mainImage.layer.cornerRadius = self.cornerRadius
            self.mainImage.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
            self.mainImage.isUserInteractionEnabled = true
            self.mainImage.addGestureRecognizer(tap)
            
            self.mainStack.insertArrangedSubview(self.mainImage, at: 0)
            
            let multiplier: CGFloat = self.delegate?.mainImageHightMultiplier() ?? 1.0
            
            self.constraintsToAdd.append(self.mainImage.heightAnchor.constraint(equalTo: self.topView.heightAnchor, multiplier: multiplier))
        }
        
        if(self.exitImage != nil){
            self.imageView = UIImageView(image: self.exitImage!)
            self.imageView.clipsToBounds = true
            self.imageView.translatesAutoresizingMaskIntoConstraints = false
            self.imageView.isUserInteractionEnabled = true
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.didSelectLeft))
            tap.cancelsTouchesInView = true
            
            self.imageView.addGestureRecognizer(tap)
            self.constraintsToAdd.append(self.imageView.widthAnchor.constraint(equalToConstant: 50))
            self.constraintsToAdd.append(self.imageView.heightAnchor.constraint(equalToConstant: 50))
            
            self.contentView.addSubview(self.imageView)
            self.contentView.bringSubviewToFront(self.imageView)
            
            self.constraintsToAdd.append(self.imageView.centerYAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5.0))
            self.constraintsToAdd.append(self.imageView.centerXAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -5.0))
        }
        
        if(width != nil){
            self.width = width ?? 300
            self.constraintsToAdd.append(self.widthAnchor.constraint(equalToConstant: self.width))
        }
        
        if(height != nil){
            self.height = heightToUse
            self.constraintsToAdd.append(self.heightAnchor.constraint(equalToConstant: self.height))
        }
        
        NSLayoutConstraint.activate(self.constraintsToAdd)
        
        self.delegate?.alertDisplayerWillAppear()
    }
    
    @objc private func didSelectLeft(){
        print("didPressCancel")
        delegate?.didPressCancel()
    }
    
    @objc private func didSelectRight(){
        print("didPressOk")
        delegate?.didPressOk()
    }
    
    @objc private func didSelectImage(){
        print("didSelectImage")
        delegate?.didSelectMainImage()
    }
    
    public func setUpButtons(_ first: String!, _ second: String? = nil){
        
        if(second == nil){
            self.leftButton.isHidden = true
            self.rightButton.setTitle(first, for: .normal)
            self.rightButton.setTitleColor(self.textColor, for: .normal)
            self.rightButton.titleLabel?.textColor = self.textColor

            self.topBorder.backgroundColor = self.decorations
            self.rightBorder.backgroundColor = UIColor.white.withAlphaComponent(0.0)
            self.leftBorder.backgroundColor = UIColor.white.withAlphaComponent(0.0)
            
            self.rightButton.constraints.forEach { (constraint) in
                if constraint.firstAttribute == .height{
                    constraint.constant = self.buttonStack.frame.width
                }
            }
            
        }else{
            self.leftButton.isHidden = false
            self.rightButton.setTitle(second, for: .normal)
            self.leftButton.setTitle(first, for: .normal)
            
            self.rightButton.titleLabel?.textColor = self.textColor
            self.leftButton.titleLabel?.textColor = self.textColor

            self.rightButton.setTitleColor(self.textColor, for: .normal)
            self.leftButton.setTitleColor(self.textColor, for: .normal)

            self.topBorder.backgroundColor = self.decorations
            self.rightBorder.backgroundColor = self.decorations
            self.leftBorder.backgroundColor = self.decorations
            
            self.rightButton.constraints.forEach { (constraint) in
                if constraint.firstAttribute == .height{
                    constraint.constant = self.buttonStack.frame.width / 2
                }
            }
            
            self.leftButton.constraints.forEach { (constraint) in
                if constraint.firstAttribute == .height{
                    constraint.constant = self.buttonStack.frame.width / 2
                }
            }
        }
        
    }
    
    
    private func setUpSpace(for label: UILabel, _ text: String = ""){
        label.text = text
        
        let size = CGSize(width: label.frame.width, height: .infinity)
        let estimatedSize = label.sizeThatFits(size)
        
        label.constraints.forEach { (constraint) in
            if constraint.firstAttribute == .height {
                constraint.constant = estimatedSize.height + 5.0
            }
        }
    }
}

public extension AlertDisplayer{
    
    override func prepareForInterfaceBuilder() {
        self.commonInit()
    }
    
    private func setUpBorders(){
        self.topBorder = self.buttonStack.alertViewHelper(edges: .top, color: self.decorations, inset: 0.0, thickness: 1.0).first!
        self.leftBorder = self.leftButton.alertViewHelper(edges: .right, color: self.decorations, inset: 0.0, thickness: 0.5).first!
        self.rightBorder = self.rightButton.alertViewHelper(edges: .left, color: self.decorations, inset: 0.0, thickness: 0.5).first!
    }
    
    private func setUpConstraints(){
        
        self.constraintsToAdd.append(self.contentView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0.0))
        self.constraintsToAdd.append(self.contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0.0))
        self.constraintsToAdd.append(self.contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0.0))
        self.constraintsToAdd.append(self.contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0.0))
        
        self.topConstraint = self.mainStack.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 0.0)
        
        self.constraintsToAdd.append(self.topConstraint)
        self.constraintsToAdd.append(self.mainStack.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 0.0))
        self.constraintsToAdd.append(self.mainStack.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 0.0))
        self.constraintsToAdd.append(self.mainStack.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: 0.0))
        
        
        self.constraintsToAdd.append(self.boldLabel.bottomAnchor.constraint(equalTo: self.normalLabel.topAnchor, constant: 5.0))
        self.constraintsToAdd.append(self.boldLabel.leadingAnchor.constraint(equalTo: self.topView.leadingAnchor, constant: 10.0))
        self.constraintsToAdd.append(self.boldLabel.trailingAnchor.constraint(equalTo: self.topView.trailingAnchor, constant: -10.0))
        self.constraintsToAdd.append(self.boldLabel.heightAnchor.constraint(equalToConstant: 50))
        
        self.constraintsToAdd.append(self.normalLabel.centerYAnchor.constraint(equalTo: self.topView.centerYAnchor, constant: 30.0))
        self.constraintsToAdd.append(self.normalLabel.heightAnchor.constraint(equalToConstant: 50))
        self.constraintsToAdd.append(self.normalLabel.leadingAnchor.constraint(equalTo: self.topView.leadingAnchor, constant: 10.0))
        self.constraintsToAdd.append(self.normalLabel.trailingAnchor.constraint(equalTo: self.topView.trailingAnchor, constant: -10.0))
        
        self.constraintsToAdd.append(self.leftButton.heightAnchor.constraint(equalToConstant: self.buttonHeight))
        self.constraintsToAdd.append(self.rightButton.heightAnchor.constraint(equalToConstant: self.buttonHeight))
        self.constraintsToAdd.append(self.buttonStack.heightAnchor.constraint(equalToConstant: self.buttonHeight))
        
        self.constraintsToAdd.append(self.topView.heightAnchor.constraint(equalToConstant: self.contentView.frame.height - self.buttonHeight))

    }
    
}

public extension UIView{
    @discardableResult
    func alertViewHelper(edges: UIRectEdge,
                         color: UIColor,
                         inset: CGFloat = 0.0,
                         thickness: CGFloat = 1.0) -> [UIView] {
        
        var borders = [UIView]()
        
        @discardableResult
        func addBorder(formats: String...) -> UIView {
            let border = UIView(frame: .zero)
            border.backgroundColor = color
            border.translatesAutoresizingMaskIntoConstraints = false
            addSubview(border)
            addConstraints(formats.flatMap {
                NSLayoutConstraint.constraints(withVisualFormat: $0,
                                               options: [],
                                               metrics: ["inset": inset, "thickness": thickness],
                                               views: ["border": border]) })
            borders.append(border)
            return border
        }
        
        
        if edges.contains(.top) || edges.contains(.all) {
            addBorder(formats: "V:|-0-[border(==thickness)]", "H:|-inset-[border]-inset-|")
        }
        
        if edges.contains(.bottom) || edges.contains(.all) {
            addBorder(formats: "V:[border(==thickness)]-0-|", "H:|-inset-[border]-inset-|")
        }
        
        if edges.contains(.left) || edges.contains(.all) {
            addBorder(formats: "V:|-inset-[border]-inset-|", "H:|-0-[border(==thickness)]")
        }
        
        if edges.contains(.right) || edges.contains(.all) {
            addBorder(formats: "V:|-inset-[border]-inset-|", "H:[border(==thickness)]-0-|")
        }
        
        return borders
    }
    
}

public class TopAlignedLabel: UILabel {
    override public func drawText(in rect: CGRect) {
        if let stringText = text {
            let stringTextAsNSString = stringText as NSString
            let labelStringSize = stringTextAsNSString.boundingRect(with: CGSize(width: self.frame.width,height: CGFloat.greatestFiniteMagnitude),
                                                                    options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                                                    attributes: [NSAttributedString.Key.font: font ?? UIFont.systemFont(ofSize: 14)],
                                                                    context: nil).size
            super.drawText(in: CGRect(x:0,y: 0,width: self.frame.width, height:ceil(labelStringSize.height)))
        } else {
            super.drawText(in: rect)
        }
    }
}
