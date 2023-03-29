//
//  GuideViewController.swift
//  PractiseSwift
//
//  Created by zengbiwang on 2023/3/23.
//

import UIKit
import RxSwift
import RxCocoa

 private let cellIdentifier = "GuideCell"

class GuideViewController: BaseViewController {
 
    private let imageNames = ["guide_40_1", "guide_40_2", "guide_40_3", "guide_40_4"]
    private let dataSubject = BehaviorRelay<[String]>(value:[])

    private  let disposeBag = DisposeBag()
    private var isHiddenNextButton = true
    //private var pageController = UIPageControl(frame: CGRect.init(x:0,y: UIScreen.main.bounds.height - 50, UIScreen.main.bounds.width, 20))
    private var pageController = UIPageControl.init(frame: CGRect.init(x: 0, y: UIScreen.main.bounds.height - 50, width:UIScreen.main.bounds.width, height: 20))
    
    private lazy var collectionView:UICollectionView={
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.itemSize = UIScreen.main.bounds.size
        layout.scrollDirection = .horizontal
        
        collectionView = UICollectionView(frame: UIScreen.main.bounds, collectionViewLayout: layout)
      
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.bounces = false
        collectionView.register(GuideCell.self, forCellWithReuseIdentifier: cellIdentifier)
        self.view.addSubview(collectionView)
        return collectionView
    }()
    
    deinit{
        JTPrint(message: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.setStatusBarHidden(false, with: .none)

        bindCollViewData()
        buildPageController()
        // Do any additional setup after loading the view.
    }
    
    private func buildPageController() {
        pageController.numberOfPages = imageNames.count
        pageController.currentPage = 0
        pageController.isEnabled = false
        view.addSubview(pageController)
    }

    private func bindCollViewData(){
//    open func dequeueReusableCell(withReuseIdentifier identifier: String, for indexPath: IndexPath) -> UICollectionViewCell

        
        
        dataSubject
        .bind(to: collectionView.rx.items) {[weak self] (collectionView, row, element)   in
           let indexPath = IndexPath(row: row, section: 0)
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! GuideCell
            cell.newImage = UIImage.init(named: element)
            if row != (self?.imageNames.count)! - 1 {
                cell.setNextButtonHidden(hidden: true)
            }
            return cell
        }
        .disposed(by: disposeBag)//scrollViewDidEndDecelerating
        
        collectionView.rx.didEndDecelerating.subscribe(onNext: { [weak self] _ in
            if self?.collectionView.contentOffset.x == UIScreen.main.bounds.width * CGFloat((self?.imageNames.count)! - 1) {
                let cell = self?.collectionView.cellForItem(at: IndexPath(row: (self?.imageNames.count)! - 1, section: 0)) as! GuideCell
                cell.setNextButtonHidden(hidden: false)
                self?.isHiddenNextButton = false
            }
        }).disposed(by: disposeBag)
        
        collectionView.rx.didScroll.subscribe(onNext: {  [weak self] _  in
            if self?.collectionView.contentOffset.x != UIScreen.main.bounds.width * CGFloat(((self?.imageNames.count)!) - 1) && !self!.isHiddenNextButton && (self?.collectionView.contentOffset.x)! > UIScreen.main.bounds.width * CGFloat((self?.imageNames.count)! - 2) {
                let cell = self?.collectionView.cellForItem(at: IndexPath(row: (self?.imageNames.count)!-1, section: 0)) as! GuideCell
                cell.setNextButtonHidden(hidden: true)
                self?.isHiddenNextButton = true
            }
        
            self?.pageController.currentPage = Int((self?.collectionView.contentOffset.x)! / UIScreen.main.bounds.width + 0.5)
        }).disposed(by: disposeBag)
        dataSubject.accept(imageNames)
    }
}
