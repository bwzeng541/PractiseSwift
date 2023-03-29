 
import UIKit
import RxSwift
import RxCocoa
class GuideCell: UICollectionViewCell {
    
    private let newImageView = UIImageView(frame: UIScreen.main.bounds)
    private let nextButton = UIButton(frame: CGRect.init(x: (UIScreen.main.bounds.width - 100) * 0.5, y: UIScreen.main.bounds.height - 110, width: 100, height: 33))
    
    var newImage: UIImage? {
        didSet {
            newImageView.image = newImage
        }
    }
    
    deinit{
        JTPrint(message: self)
    }
   private  let disposeBag = DisposeBag()

    override init(frame: CGRect) {
        super.init(frame: frame)
        newImageView.clipsToBounds = true;
        newImageView.contentMode = .scaleAspectFill
        contentView.addSubview(newImageView)
        
        nextButton.setBackgroundImage(R.image.icon_next(), for: .normal)
        nextButton.isHidden = true
        contentView.addSubview(nextButton)
        nextButton.rx.tap.asObservable().debounce(.milliseconds(300), scheduler:  MainScheduler.instance ).subscribe(onNext: { _ in
            let notification = Notification(name: Notification.Name(GuideViewControllerDidFinish), object: nil, userInfo: nil)
            NotificationCenter.default.post(notification)
        }).disposed(by: disposeBag)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setNextButtonHidden(hidden: Bool) {
        nextButton.isHidden = hidden
    }
    
   
}
