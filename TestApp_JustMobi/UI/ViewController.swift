//
//  ViewController.swift
//  TestApp_JustMobi
//
//  Created by Pavel Gritskov on 18.07.25.
//

import UIKit

class ViewController: UIViewController {
    
    enum Appearance {
        static let circleGiftViewWidth: CGFloat = 168
    }
    
    private lazy var giftView = CircleWithGiftView(imageName: .giftBoxRed)
    
    private var time = 1200
    private weak var timer: Timer?
    
    // MARK: - Life Circle

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        giftView.startAnimation()
        giftView.setTime(time)
        createTimer()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        giftView.stopAnimation()
        stopTimer()
    }
}

// MARK: - Setup

private extension ViewController {
    
    func setup() {
        view.backgroundColor = .white
        view.addSubviewsForAutoLayout(giftView)
    }
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            giftView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            giftView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            giftView.widthAnchor.constraint(equalToConstant: Appearance.circleGiftViewWidth),
            giftView.heightAnchor.constraint(equalToConstant: Appearance.circleGiftViewWidth),
        ])
    }
}

// MARK: - Timer

private extension ViewController {
    
    func createTimer() {
        stopTimer()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerHandler), userInfo: nil, repeats: true)
        timer?.tolerance = 0.4
    }
    
    @objc func timerHandler() {
        time -= 1
        giftView.setTime(time)
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}
