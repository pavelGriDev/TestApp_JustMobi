//
//  ViewController.swift
//  TestApp_JustMobi
//
//  Created by Pavel Gritskov on 18.07.25.
//

import UIKit

class ViewController: UIViewController {
    
    private lazy var giftView = CircleWithGiftView(imageName: .giftBoxRed)

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.backgroundColor = .white
        print(#function)
        
        view.addSubviewsForAutoLayout(giftView)
        
        let size: CGFloat = 168
        
        NSLayoutConstraint.activate([
            giftView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            giftView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            giftView.widthAnchor.constraint(equalToConstant: size),
            giftView.heightAnchor.constraint(equalToConstant: size),
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        giftView.timerText = "00:59:59"
    }
}

final class CircleWithGiftView: UIView {
    
    /*
     - start timer
     - tap gesture
     - reset timer
     - stop timer
     
     - outside image
     - adaptive size
     */
    
    var timerText: String? {
        get {
            textLabel.text
        }
        set {
            textLabel.text = newValue
        }
    }
    
    private let imageName: ImageResource
    
    // CABasicAnimation maybe...
    private lazy var imageView: UIImageView = {
        let view = UIImageView(image: UIImage(resource: self.imageName))
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private lazy var textLabel: UILabel = {
        let label = StrokedTextLabel(strokeSize: 2, strokeColor: .black)
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.2
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        return label
    }()
    
    init(imageName: ImageResource) {
        self.imageName = imageName
        super.init(frame: .zero)
        
        self.backgroundColor = .black.withAlphaComponent(0.6)
        clipsToBounds = true
        
        self.addSubviewsForAutoLayout(imageView, textLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.bounds.width / 2
        setupLayout()
    }
    
    private func setupLayout() {
        let horizontalInset = self.bounds.width * 0.18
        let bottomInset = self.bounds.height * 0.36
        let textBottomInset = self.bounds.height * 0.18
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: horizontalInset),
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -horizontalInset),
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -bottomInset),
            
            textLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 6),
            textLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: 8),
            textLabel.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -8),
            textLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -textBottomInset)
        ])
    }
}
