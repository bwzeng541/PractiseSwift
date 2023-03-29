//
//  QRCodeViewController.swift
//  PractiseSwift
//
//  Created by zengbiwang on 2023/3/25.
//

import UIKit
import AVFoundation
import RxSwift
class QRCodeViewController: BaseViewController,AVCaptureMetadataOutputObjectsDelegate {

    private var titleLabel = UILabel()
    private var captureSession: AVCaptureSession?
    private var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    private var animationLineView = UIImageView()
    private var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        buildNavigationItem()

        buildInputAVCaptureDevice()

        buildFrameImageView()
        
        buildTitleLabel()
        
        buildAnimationLineView()
    }
   
    // MARK: - Build UI
    private func buildNavigationItem() {
        navigationItem.title = "店铺二维码"
        
        navigationController?.navigationBar.barTintColor = LFBNavigationBarWhiteBackgroundColor
    }
    
    deinit{
        JTPrint(message: self)
    }
    
    private func buildTitleLabel() {
        
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.frame = CGRect.init(x: 0, y: 340, width: ScreenWidth, height: 30)
        titleLabel.textAlignment = .center
        view.addSubview(titleLabel)
    }
    
    private func buildInputAVCaptureDevice(){
        
    }
    
    private func buildFrameImageView(){
        let lineT = [CGRectMake(0, 0, ScreenWidth, 100),
            CGRectMake(0, 100, ScreenWidth * 0.2, ScreenWidth * 0.6),
            CGRectMake(0, 100 + ScreenWidth * 0.6, ScreenWidth, ScreenHeight - 100 - ScreenWidth * 0.6),
            CGRectMake(ScreenWidth * 0.8, 100, ScreenWidth * 0.2, ScreenWidth * 0.6)]
        for lineTFrame in lineT {
            buildTransparentView(lineTFrame)
        }
        
        let lineR = [CGRectMake(ScreenWidth * 0.2, 100, ScreenWidth * 0.6, 2),
            CGRectMake(ScreenWidth * 0.2, 100, 2, ScreenWidth * 0.6),
            CGRectMake(ScreenWidth * 0.8 - 2, 100, 2, ScreenWidth * 0.6),
            CGRectMake(ScreenWidth * 0.2, 100 + ScreenWidth * 0.6, ScreenWidth * 0.6, 2)]
        
        for lineFrame in lineR {
            buildLineView(lineFrame)
        }
        
        let yellowHeight: CGFloat = 4
        let yellowWidth: CGFloat = 30
        let yellowX: CGFloat = ScreenWidth * 0.2
        let bottomY: CGFloat = 100 + ScreenWidth * 0.6
        let lineY = [CGRectMake(yellowX, 100, yellowWidth, yellowHeight),
            CGRectMake(yellowX, 100, yellowHeight, yellowWidth),
            CGRectMake(ScreenWidth * 0.8 - yellowHeight, 100, yellowHeight, yellowWidth),
            CGRectMake(ScreenWidth * 0.8 - yellowWidth, 100, yellowWidth, yellowHeight),
            CGRectMake(yellowX, bottomY - yellowHeight + 2, yellowWidth, yellowHeight),
            CGRectMake(ScreenWidth * 0.8 - yellowWidth, bottomY - yellowHeight + 2, yellowWidth, yellowHeight),
            CGRectMake(yellowX, bottomY - yellowWidth, yellowHeight, yellowWidth),
            CGRectMake(ScreenWidth * 0.8 - yellowHeight, bottomY - yellowWidth, yellowHeight, yellowWidth)]
        
        for yellowRect in lineY {
            buildYellowLineView(yellowRect)
        }
    }
    
    private func buildLineView(_ frame: CGRect) {
        let view1 = UIView(frame: frame)
        view1.backgroundColor = UIColor.RGB(r:230, g: 230, b: 230)
        view.addSubview(view1)
    }
    
    private func buildYellowLineView(_ frame: CGRect) {
        let yellowView = UIView(frame: frame)
        yellowView.backgroundColor = LFBNavigationYellowColor
        view.addSubview(yellowView)
    }
    
    private func buildTransparentView(_ frame: CGRect) {
        let tView = UIView(frame: frame)
        tView.backgroundColor = UIColor.black
        tView.alpha = 0.5
        view.addSubview(tView)
    }
    
    private func buildAnimationLineView(){
        animationLineView.image = UIImage(named: "yellowlight")
        view.addSubview(animationLineView)
        Observable<Int>.timer(.milliseconds(30), period: .milliseconds(5000), scheduler:MainScheduler.instance)
            .subscribe(onNext: {[weak self] num in
                self?.animationLineView.frame = CGRectMake(ScreenWidth * 0.2 + ScreenWidth * 0.1 * 0.5, 100, ScreenWidth * 0.5, 20)
                UIView.animate(withDuration: 2.5) { () -> Void in
                }
                
                UIView.animate(withDuration: 2.5, animations: { [weak self] in
                    self?.animationLineView.frame.origin.y += ScreenWidth * 0.55
                }){ (complete) in
                    UIView.animate(withDuration: 2.5) { () -> Void in
                        self?.animationLineView.frame.origin.y = 100
                    }
                }
                
            }).disposed(by: disposeBag)
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection)
    {
        if (metadataObjects != nil && metadataObjects.count > 0) {
            var metadataObject = metadataObjects.first as! AVMetadataMachineReadableCodeObject
            if (metadataObject.type == AVMetadataObject.ObjectType.qr) {
                var message =  metadataObject.stringValue
         
         }
        }
    }
}
