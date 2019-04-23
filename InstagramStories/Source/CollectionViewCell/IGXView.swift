//
//  IGXView.swift
//  InstagramStories
//
//  Created by Kumar, Ranjith B. (623-Extern) on 12/04/19.
//  Copyright © 2019 DrawRect. All rights reserved.
//

import Foundation
import UIKit

protocol IGXMisc: class {
    func showLoader(color: UIColor)
    func hideLoader(color: UIColor)
}

extension IGXMisc where Self: IGXView {
    func showLoader(color: UIColor = .black) {
        backgroundColor = color
    }
    
    func hideLoader(color: UIColor = .clear) {
        backgroundColor = color
    }
}

protocol IGXContent: class {
    associatedtype cType
}

//This class can act as Person class
//ScrollView children should have Parent class of IGXView but the instance is based on the MIME Type whether it is a IGImageView or IGPlayerView
class IGXView: UIView, IGXMisc,IGXContent {
    typealias cType = UIView
    
    enum ContentState {
        case isLoading, isLoaded, isFailed
    }
    
    lazy var retryBtn: UIButton = {
        let bt = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        bt.setTitle("Re-try", for: .normal)
        bt.center = center
        bt.addTarget(self, action: #selector(loadContent), for: .touchUpInside)
        return bt
    }()
    
    let snap: IGSnap
    var contentState: ContentState = .isLoading {
        didSet {
            switch contentState {
            case .isLoading:
                showLoader()
            case .isLoaded:
                hideLoader()
            case .isFailed:
                hideLoader(color: UIColor.black.withAlphaComponent(0.2))//dimmed
                addSubview(retryBtn)
            }
        }
    }
    
    init(frame: CGRect, snap:IGSnap) {
        self.snap = snap
        super.init(frame: frame)
        self.backgroundColor = .black
        defer {
            loadContent()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func loadContent() {
        fatalError("This method must be overridden")
    }
    
}

class IGImageView: IGXView {
    typealias cType = UIImageView
    let imageView = UIImageView()
    override init(frame: CGRect, snap: IGSnap) {
//        children = UIImageView(frame: frame)
        super.init(frame: frame, snap: snap)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //Add your Image related stuff here
    @objc override func loadContent() {
        //start request this image using sdwebimage using snap.url
        imageView.setImage(url: snap.url, style: .squared) {[weak self] (result) in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    break
//                    strongSelf.startProgressors()
                case .failure(_):
                    break
//                    strongSelf.showRetryButton(with: url, for: snapView)
                }
            }
        }
    }
    
}

class IGVideoView: IGXView {
    typealias cType = UIView
    //Add your Video related stuff here
    @objc override func loadContent() {
        //start request this video using avplayer with contents of url
    }
}