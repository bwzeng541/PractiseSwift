//
//  SearchProductViewController.swift
//  PractiseSwift
//
//  Created by zengbiwang on 2023/3/25.
//

import UIKit
import RxSwift
class SearchProductViewController: AnimationViewController {
    private let contentScrollView = UIScrollView(frame: ScreenBounds)
    private let searchBar = UISearchBar()
    private var hotSearchView: SearchView?
    private var historySearchView: SearchView?
    private let cleanHistoryButton: UIButton = UIButton()
    private var searchCollectionView: LFBCollectionView?
    private var goodses:[Goods]? = []
    private var collectionHeadView: NotSearchProductsView?
    private var yellowShopCar: YellowShopCarView?
    
    private  let disposeBag = DisposeBag()
    private  let single = PublishSubject<Void >()
    private let reqeustSignal = PublishSubject<String?>()

    
    private  let searchHostMode = SearhHotViewMode()
    private  var searchProducts :SearchProducts?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        buildContentScrollView()

        buildSearchBar()
        
        buildCleanHistorySearchButton()
        
        loadHotSearchButtonData()
        
        loadHistorySearchButtonData()
        
        buildsearchCollectionView()
        
        buildYellowShopCar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.barTintColor =  view.backgroundColor//LFBNavigationBarWhiteBackgroundColor
        guard searchCollectionView != nil else{ return }
        if searchCollectionView != nil && goodses!.count > 0 {
            searchCollectionView!.reloadData()
        }
    }
    
    
    deinit{
        JTPrint(message:self)
    }
    func buildContentScrollView(){
        contentScrollView.delegate = self
        contentScrollView.backgroundColor = view.backgroundColor
        contentScrollView.alwaysBounceVertical = true
        view.addSubview(contentScrollView)
    }

    func buildSearchBar(){
        (navigationController as! BaseNavigationController).backBtn.frame = CGRectMake(0, 0, 10, 40)
        
        let tmpView = UIView(frame: CGRectMake(0, 0, ScreenWidth * 0.8, 30))
        tmpView.backgroundColor = UIColor.white
        tmpView.layer.masksToBounds = true
        tmpView.layer.cornerRadius = 6
        tmpView.layer.borderColor = UIColor(red: 100 / 255.0, green: 100 / 255.0, blue: 100 / 255.0, alpha: 1).cgColor
        tmpView.layer.borderWidth = 0.2
        let image = tmpView.screenshot
        
        searchBar.frame = CGRectMake(0, 0, ScreenWidth * 0.9, 30)
        searchBar.placeholder = "请输入商品名称"
        searchBar.barTintColor = UIColor.white
        searchBar.keyboardType = UIKeyboardType.default
        searchBar.setSearchFieldBackgroundImage(image, for: .normal)
        
        searchBar.rx.searchButtonClicked.subscribe(onNext: {[weak self] event in
            if (self?.searchBar.text?.length)! > 0 {
                self?.writeHistorySearchToUserDefault((self?.searchBar.text!)!)
                
                self?.loadProductsWithKeyword((self?.searchBar.text!)!)
            }
        }).disposed(by: disposeBag)
        
        searchBar.rx.value.subscribe(onNext: { [weak self] evnt in
            if evnt?.length == 0 {
                self?.searchCollectionView?.isHidden = true
                self?.yellowShopCar?.isHidden = true
            }
        }).disposed(by: disposeBag)
        
        navigationItem.titleView = searchBar
        
        
        let navVC = navigationController as! BaseNavigationController
        let leftBtn = navigationItem.leftBarButtonItem?.customView as? UIButton
        leftBtn!.rx.tap.subscribe(onNext: {[weak self] _ in
            self?.searchBar.endEditing(false)
        }).disposed(by: disposeBag)
        navVC.isAnimation = false
    }
    
    func buildCleanHistorySearchButton(){
        cleanHistoryButton.setTitle("清 空 历 史", for: .normal)
        cleanHistoryButton.setTitleColor(UIColor.RGB(r:163, g: 163, b: 163), for: .normal)
        cleanHistoryButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        cleanHistoryButton.backgroundColor = view.backgroundColor
        cleanHistoryButton.layer.cornerRadius = 5
        cleanHistoryButton.layer.borderColor = UIColor.RGB(r:200, g: 200, b: 200).cgColor
        cleanHistoryButton.layer.borderWidth = 0.5
        cleanHistoryButton.isHidden = true
        cleanHistoryButton.addTarget(self, action: #selector(self.cleanSearchHistorySearch), for: .touchUpInside)
        contentScrollView.addSubview(cleanHistoryButton)
    }
    
    func loadHotSearchButtonData(){
        hotSearchView = SearchView(frame: CGRectMake(10, 20, ScreenWidth - 20, 100),searchTitleText: "热门搜索")
        contentScrollView.addSubview(hotSearchView!)
 

        let out = searchHostMode.transform(SearhHotViewMode.Input(reqeustSignal: single) )
        out.databaseReuslt.subscribe(onNext:{[weak self] event in
            switch event{
            case .success(let ret):
                self?.hotSearchView?.updateBtns(ret, searchButtonClickCallback: {[weak self] str ->() in
                    self?.writeHistorySearchToUserDefault(str)
                    self?.searchBar.text = str
                    self?.loadProductsWithKeyword(str)
                })
                self?.hotSearchView!.frame.size.height = (self?.hotSearchView!.searchHeight)!
            case .failure(_):
                self?.hotSearchView?.updateBtns([], searchButtonClickCallback: { str ->() in })
                self?.hotSearchView!.frame.size.height = (self?.hotSearchView!.searchHeight)!
                self?.updateScorViewContent()
            }
        }).disposed(by: disposeBag)
        single.onNext(())
    }
    
    func updateScorViewContent(){
        self.contentScrollView.contentSize = CGSize.init(width: 0, height: (hotSearchView?.size.height ?? 0)+(historySearchView?.size.height ?? 0)+50)
    }
    
    func loadHistorySearchButtonData(){
        if historySearchView != nil {
            historySearchView?.removeFromSuperview()
            historySearchView = nil
        }
        
 
        let array = UserDefaults.standard.object(forKey: LFBSearchViewControllerHistorySearchArray) as? [String]
        if array?.count ?? 0 > 0 {
            historySearchView = SearchView(frame: CGRectMake(10, hotSearchView!.maxY+20, ScreenWidth-20, 0), searchTitleText: "历史记录")
            historySearchView?.updateBtns(array!, searchButtonClickCallback: {[weak self] str in
                self?.searchBar.text = str
                self?.loadProductsWithKeyword(str)
            })
            historySearchView!.frame.size.height = historySearchView!.searchHeight
            contentScrollView.addSubview(historySearchView!)
            updateCleanHistoryButton(false)
        }
    }
    
    private func updateCleanHistoryButton(_ hidden: Bool) {
        if historySearchView != nil {
            cleanHistoryButton.frame = CGRectMake(0.1 * ScreenWidth, historySearchView!.frame.maxY + 20, ScreenWidth * 0.8, 40)
        }
        cleanHistoryButton.isHidden = hidden
    }
    
    
    func buildsearchCollectionView(){
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 0, left: HomeCollectionViewCellMargin, bottom: 0, right: HomeCollectionViewCellMargin)
        layout.headerReferenceSize = CGSize.init(width: 0, height: HomeCollectionViewCellMargin)
        
        searchCollectionView = LFBCollectionView(frame: CGRectMake(0, 44+kSafeAreaTop, ScreenWidth, ScreenHeight - kSafeAreaBottom-(44+kSafeAreaTop)), collectionViewLayout: layout)
        searchCollectionView!.backgroundColor = LFBGlobalBackgroundColor
        searchCollectionView!.delegate = self
        searchCollectionView!.dataSource = self
        
        collectionHeadView = NotSearchProductsView(frame: CGRectMake(0, -80, ScreenWidth, 80))
        searchCollectionView?.addSubview(collectionHeadView!)
        searchCollectionView?.contentInset = UIEdgeInsets(top: 80, left: 0, bottom: 30, right: 0)
        searchCollectionView!.register(HomeCell.self, forCellWithReuseIdentifier: "Cell")
        searchCollectionView?.register(HomeCollectionFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "footerView")
        searchCollectionView?.register(HomeCollectionFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "footerView")
        view.addSubview(searchCollectionView!)
        
        /*
        searchCollectionView!.rx.didScroll.subscribe(onNext:{[weak self] event in
            self?.searchBar.endEditing(false)
        })*/
        searchCollectionView?.isHidden = true
    }

    
    func buildYellowShopCar(){
        weak var tmpSelf = self
        
        yellowShopCar = YellowShopCarView(frame: CGRectMake(ScreenWidth - 70, ScreenHeight - 70 - NavigationH, 61, 61), shopViewClick: { () -> () in
            let shopCarVC = ShopCartViewController()
            let nav = BaseNavigationController(rootViewController: shopCarVC)
            tmpSelf!.present(nav, animated: true, completion: nil)
        })
        yellowShopCar?.isHidden = true
        view.addSubview(yellowShopCar!)
    }
    
    func writeHistorySearchToUserDefault(_ str: String){
        var historySearch = UserDefaults.standard.object(forKey: LFBSearchViewControllerHistorySearchArray) as? [String]
        if historySearch == nil{
            historySearch = []
        }
        for text in historySearch! {
            if text == str {
                return
            }
        }
        historySearch!.append(str)
        UserDefaults.standard.set(historySearch, forKey: LFBSearchViewControllerHistorySearchArray)
        loadHistorySearchButtonData()
    }
    
    func loadProductsWithKeyword(_ str:String){
        if (str == nil || str.length == 0)
        {
            return
        }
            
            if (searchProducts == nil){
              searchProducts = SearchProducts()
              let out = searchProducts?.transform(SearchProducts.Input(reqeustSignal: reqeustSignal.asObservable()))
                out?.searching.subscribe(onNext: { ret in
                    if ret {
                        MBConfiguredHUD.hide()
                    }
                    else{
                        MBConfiguredHUD.showMessage("Waiting...")
                    }
                    print("ret="+ret.string)
                }).disposed(by: disposeBag)
                out?.databaseReuslt.subscribe(onNext: {[weak self] ret in
                    switch ret{
                    case .success(let value):
                        if value.count > 0 {
                            self?.goodses = value
                            self?.searchCollectionView?.isHidden = false
                            self?.yellowShopCar?.isHidden = false
                            self?.searchCollectionView?.reloadData()
                            self?.collectionHeadView?.setSearchProductLabelText(text: str)
                        }
                    case .failure(_):break
                    }
                }).disposed(by: disposeBag)
            }
        reqeustSignal.onNext(str)
       
    }
        
        
       @objc func cleanSearchHistorySearch() {
           var historySearch = UserDefaults.standard.object(forKey: LFBSearchViewControllerHistorySearchArray) as? [String]
           historySearch?.removeAll()
           UserDefaults.standard.set(historySearch, forKey: LFBSearchViewControllerHistorySearchArray)
           loadHistorySearchButtonData()
           updateCleanHistoryButton(true)
        }
}



extension SearchProductViewController: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.searchBar.endEditing(false)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return goodses?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)  as! HomeCell
        cell.goods = goodses![indexPath.row]
        weak var tmpSelf = self
        cell.addButtonClick = ({ (imageView) -> () in
            tmpSelf?.addProductsToBigShopCarAnimation(imageView)
        })
        
        return cell
    }
   
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSize = CGSize.init(width: (ScreenWidth - HomeCollectionViewCellMargin * 2) * 0.5 - 4, height: 250)
        return itemSize

    }
   
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int)->CGSize
    {
        if goodses?.count ?? 0 <= 0 || goodses == nil {
            return CGSize.init(width: 0, height: 0)
        }
        return CGSize.init(width:ScreenWidth, height: 30)

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int)->CGSize {
        return CGSize.init(width:0, height: 0)
}

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter {
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "footerView", for: indexPath) as! HomeCollectionFooterView

            footerView.setFooterTitle("无更多商品",  UIColor.RGB(r:50, g: 50, b: 50))

            return footerView

        } else {
            return collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "footerView", for: indexPath)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

