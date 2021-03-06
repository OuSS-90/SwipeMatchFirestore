//
//  CardView.swift
//  SwipeMatchFirestore
//
//  Created by OuSS on 4/11/19.
//  Copyright © 2019 OuSS. All rights reserved.
//

import UIKit
import SDWebImage

protocol CardViewDelegate {
    func didTapMoreInfo(cardViewModel: CardViewModel?)
    func didSwipe(didLike: Bool)
}

class CardView: UIView {
    
    var delegate: CardViewDelegate?
    var nextCardView: CardView?
    
    var cardViewModel: CardViewModel? {
        didSet{
            guard let cardViewModel = cardViewModel else { return }
            
            swipingPhotosController.cardViewModel = cardViewModel
            informationLabel.attributedText = cardViewModel.attributedText
        }
    }
    
    let swipingPhotosController = SwipingPhotosController(isCardViewMode: true)
    
    fileprivate let informationLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .white
        return label
    }()
    
    fileprivate let moreInfoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "info_icon").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleMoreInfo), for: .touchUpInside)
        return button
    }()
    
    fileprivate let gradientLayer = CAGradientLayer()
    
    //Configuration
    fileprivate let threshold: CGFloat = 100

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        addGestureRecognizer(panGesture)
        
        /*let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        addGestureRecognizer(tapGesture)*/
    }
    
    override func layoutSubviews() {
        gradientLayer.frame = frame
    }
    
    fileprivate func setupLayout() {
        layer.cornerRadius = 10
        clipsToBounds = true
        
        let swipingPhotosView = swipingPhotosController.view!
        addSubview(swipingPhotosView)
        
        setupGradientLayer()
        
        addSubview(informationLabel)
        
        swipingPhotosView.fillSuperview()
        informationLabel.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: UIEdgeInsets(top: 0, left: 16, bottom: 16, right: 16))
        
        addSubview(moreInfoButton)
        moreInfoButton.anchor(top: nil, leading: nil, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 16, right: 16), size: .init(width: 44, height: 44))
    }
    
    fileprivate func setupGradientLayer(){
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0.5, 1.1]
        layer.addSublayer(gradientLayer)
    }
    
    @objc func handlePanGesture(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .began:
            superview?.subviews.forEach{$0.layer.removeAllAnimations()}
        case .changed:
            handleChanged(gesture)
        case .ended:
            handleEnded(gesture)
        default: ()
        }
    }
    
    @objc fileprivate func handleMoreInfo() {
        delegate?.didTapMoreInfo(cardViewModel: cardViewModel)
    }
    
    fileprivate func handleChanged(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: nil)
        let degree: CGFloat = translation.x / 20
        let angle = degree * .pi / 180
        let rotationTransform = CGAffineTransform(rotationAngle: angle)
        transform = rotationTransform.translatedBy(x: translation.x, y: translation.y)
    }
    
    fileprivate func handleEnded(_ gesture: UIPanGestureRecognizer) {
        let translationDirection: CGFloat = gesture.translation(in: nil).x > 0 ? 1 : -1
        let shouldDismissCard = abs(gesture.translation(in: nil).x) > threshold
        
        if shouldDismissCard {
            let didLike = translationDirection == 1
            delegate?.didSwipe(didLike: didLike)
        } else {
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: .curveEaseOut, animations: {
                self.transform = .identity
            })
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
