
import UIKit

class LFBTableView: UITableView {

    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        delaysContentTouches = false
        canCancelContentTouches = true
        separatorStyle = .none
        
        let wrapView = subviews.first
        
        if wrapView != nil && NSStringFromClass((wrapView?.classForCoder)!).hasPrefix("WrapperView") {

            for gesture in wrapView!.gestureRecognizers! {
                if (NSStringFromClass(gesture.classForCoder).contains("DelayedTouchesBegan")) {
                    gesture.isEnabled = false
                    break
                }
            }
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func touchesShouldCancel(in view: UIView) -> Bool {
        if view is (UIControl) {
            return true
        }
        
        return super.touchesShouldCancel(in: view)
    }
}
