//
//  DetailViewController.swift
//  HelloPhotoViewer
//
//  Created by Lai Zih Ci on 2016/12/21.
//  Copyright © 2016年 ZihCi. All rights reserved.
//

import UIKit
import QuartzCore
class DetailViewController: UIViewController, UIScrollViewDelegate, CAAnimationDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        self.automaticallyAdjustsScrollViewInsets = false
        self.configureView()
        
        let toRight = UISwipeGestureRecognizer(target: self, action: #selector(toRightAction))
        
        toRight.direction = .right
        
        imageView.addGestureRecognizer(toRight)
        imageView.isUserInteractionEnabled = true
        
        slider.isHidden = true
        
        // hied play button if targetIndex is -1
        if targetIndex == -1 {
            self.navigationItem.rightBarButtonItem = nil
        }
    }
    
    var timer:Timer?
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var slider: UISlider!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBAction func toLeftAction(_ sender: Any) {
        
        let transition = CATransition()
        transition.delegate = self
        // 運作的時間
        transition.duration = 0.3
        // 變化的速度
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        // 切換模式
        transition.type = kCATransitionPush
        // 方向
        transition.subtype = kCATransitionFromRight
        // 將動畫加入imageView 的layer層
        imageView.layer.add(transition, forKey: nil)
        
        targetIndex += 1
        if targetIndex >= DataManager.shared.totalCount() {
            targetIndex = 0
        }
        configureView()
        
        print("function:",#function, ",line:", #line,  "exevuted.")
    }
    
    func toRightAction() {
        
        let transition = CATransition()
        // 運作的時間
        transition.duration = 0.3
        // 變化的速度
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        // 切換模式
        transition.type = kCATransitionPush
        // 方向
        transition.subtype = kCATransitionFromLeft
        // 將動畫加入imageView 的layer層
        imageView.layer.add(transition, forKey: nil)
        
        nextImage()
    }
    
    func nextImage() {
        targetIndex -= 1
        if targetIndex < 0 {
            targetIndex = DataManager.shared.totalCount() - 1
        }
        configureView()
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        print("animationDidStop")
    }
    
    func animationDidStart(_ anim: CAAnimation) {
        print("animationDidStart")
    }

    
    @IBAction func playStopBtnPressed(_ sender: Any) {
        
        if slider.isHidden {
            // will start to play slide show
            slider.isHidden = false
            let stopBtn = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(playStopBtnPressed(_:)))
            self.navigationItem.rightBarButtonItem = stopBtn
            
            // Start timer
            let timeInterval = TimeInterval(slider.value)
            timer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(toLeftAction(_:)), userInfo: nil, repeats: true)
            
        } else {
            // will stop playing slide show
            slider.isHidden = true
            let playBtn = UIBarButtonItem(barButtonSystemItem: .play, target: self, action: #selector(playStopBtnPressed(_:)))
            self.navigationItem.rightBarButtonItem = playBtn
            
            // Stop timer
            timer?.invalidate()
            timer = nil
        }
    }

    @IBAction func timeIntervalValueChanged(_ sender: Any) {
        
        // Stop timer
        timer?.invalidate()
        timer = nil
        
        // Start timer
        let timeInterval = TimeInterval(slider.value)
        timer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(toLeftAction(_:)), userInfo: nil, repeats: true)
    }
    
    // Animation
    @IBAction func nextPage(_ sender: UIBarButtonItem) {
        nextImage()
        animation()
    }
    func animation() {
        UIView.beginAnimations("asdf", context: nil)
        UIView.setAnimationDelegate(self)
        UIView.setAnimationDidStop(#selector(animationStop))
        UIView.setAnimationDuration(2)
        UIView.setAnimationCurve(.easeOut)
        UIView.setAnimationTransition(.curlDown, for: imageView, cache: true)
        UIView.commitAnimations()
    }
    
    func animationStop() {
        print("DidStop")
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func configureView() {
        
        guard targetIndex >= 0 else {
            return
        }
        guard let image = DataManager.shared.getImage(at: targetIndex) else {
            return
        }
        guard imageView != nil else {
            return
        }
        
        imageView.image = image
        
        scrollView.contentSize = image.size
        scrollView.maximumZoomScale = 3.0
        scrollView.minimumZoomScale = 1.0
        scrollView.zoomScale = 1.0
        scrollView.delegate = self
    }

    var targetIndex = -1 {
        didSet {
            // Update the view.
            self.configureView()
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        // stop timer if it is still exist.
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
    }
    
    deinit {
        print("deinit")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

