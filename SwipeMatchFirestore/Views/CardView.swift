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
}

class CardView: UIView {
    
    var delegate: CardViewDelegate?
    
    var cardViewModel: CardViewModel? {
        didSet{
            guard let cardViewModel = cardViewModel else { return }
            guard let imageUrl = cardViewModel.imageUrls.first else { return }
            guard let url = URL(string: imageUrl) else { return }
            imageView.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "photo_placeholder"))
            informationLabel.attributedText = cardViewModel.attributedText
            (0..<cardViewModel.imageUrls.count).forEach { (_) in
                let view = UIView()
                view.backgroundColor = deseletedBarColor
                barsStackView.addArrangedSubview(view)
            }
            barsStackView.arrangedSubviews.first?.backgroundColor = .white
            setupImageIndexObserver()
        }
    }
    
    fileprivate let imageView: UIImageView = {
        let imageV = UIImageView()
        imageV.contentMode = .scaleAspectFill
        return imageV
    }()
    
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
    
    fileprivate let deseletedBarColor = UIColor(white: 0, alpha: 0.1)
    fileprivate let barsStackView = UIStackView()
    fileprivate let gradientLayer = CAGradientLayer()
    
    //Configuration
    fileprivate let threshold: CGFloat = 100

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        addGestureRecognizer(panGesture)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        addGestureRecognizer(tapGesture)
    }
    
    override func layoutSubviews() {
        gradientLayer.frame = frame
    }
    
    fileprivate func setupLayout() {
        layer.cornerRadius = 10
        clipsToBounds = true
        
        addSubview(imageView)
        setupBarsStackView()
        setupGradientLayer()
        addSubview(informationLabel)
        
        imageView.fillSuperview()
        informationLabel.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: UIEdgeInsets(top: 0, left: 16, bottom: 16, right: 16))
        
        addSubview(moreInfoButton)
        moreInfoButton.anchor(top: nil, leading: nil, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 16, right: 16), size: .init(width: 44, height: 44))
    }
    
    fileprivate func setupBarsStackView() {
        addSubview(barsStackView)
        barsStackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: UIEdgeInsets(top: 8, left: 8, bottom: 0, right: 8), size: CGSize(width: 0, height: 4))
        barsStackView.distribution = .fillEqually
        barsStackView.spacing = 5
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
    
    @objc func handleTapGesture(gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: nil)
        let shouldAdvance = location.x > frame.width / 2
        if shouldAdvance {
            cardViewModel?.advanceToNextPhoto()
        } else {
            cardViewModel?.backToPreviousPhoto()
        }
    }
    
    @objc fileprivate func handleMoreInfo() {
        delegate?.didTapMoreInfo(cardViewModel: cardViewModel)
    }
    
    fileprivate func setupImageIndexObserver() {
        cardViewModel?.imageIndexObserver = { [weak self] (index, imageUrl) in
            if let imageUrl = imageUrl, let url = URL(string: imageUrl) {
                self?.imageView.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "photo_placeholder"))
            }
            self?.barsStackView.arrangedSubviews.forEach { (view) in
                view.backgroundColor = self?.deseletedBarColor
            }
            self?.barsStackView.arrangedSubviews[index].backgroundColor = .white
        }
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
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: .curveEaseOut, animations: {
            if shouldDismissCard {
                self.frame = CGRect(x: 800 * translationDirection, y: 0, width: self.frame.width, height: self.frame.height)
            } else {
                self.transform = .identity
            }
        }) { (_) in
            self.transform = .identity
             if shouldDismissCard {
                self.removeFromSuperview()
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
