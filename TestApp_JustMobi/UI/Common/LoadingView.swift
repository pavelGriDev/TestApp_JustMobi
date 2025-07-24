//
//  LoadingView.swift
//  TestApp_JustMobi
//
//  Created by Pavel Gritskov on 24.07.25.
//

import UIKit

final class LoadingView: UIView {
    
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.color = .textBlue
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        setupLayout()
    }
    
    func start() {
        self.isHidden = false
        loadingIndicator.startAnimating()
    }
    
    func stop() {
        self.isHidden = true
        loadingIndicator.stopAnimating()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension LoadingView {
    
    func setup() {
        backgroundColor = .black
        addSubviewsForAutoLayout(loadingIndicator)
        self.isHidden = true
    }
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
