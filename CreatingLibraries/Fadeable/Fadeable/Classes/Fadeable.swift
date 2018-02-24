import UIKit

public protocol Fadeable : class {
    var alpha: CGFloat {get set}
    
    func fadeIn(duration: TimeInterval, delay: TimeInterval, completion: @escaping (Bool) -> Void)
    func fadeOut(duration: TimeInterval, delay: TimeInterval, completion: @escaping (Bool) -> Void)
}

public extension Fadeable {
    public func fadeIn (duration: TimeInterval = 1.0,
                                 delay: TimeInterval = 0.0,
                                 completion: @escaping ((Bool)->Void) = {(finished: Bool)->Void in}){
        
        UIView.animate(
            withDuration: duration,
            delay: delay,
            options: UIViewAnimationOptions.curveEaseOut,
            animations:  {
                self.alpha = 1.0;
        },
            completion: completion)
    }
    
    public func fadeOut (duration: TimeInterval = 1.0,
                                  delay: TimeInterval = 0.0,
                                  completion: @escaping ((Bool)->Void) = {(finished: Bool)->Void in}){
        UIView.animate(
            withDuration: duration,
            delay: delay,
            options: UIViewAnimationOptions.curveEaseOut,
            animations:  {
                self.alpha = 0.0;
        },
            completion: completion)
    }
}

extension UIView : Fadeable {
    
}
