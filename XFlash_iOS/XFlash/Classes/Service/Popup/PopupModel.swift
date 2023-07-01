//
//  PopupModel.swift
//  XFlash
//
//  Created by Felix on 2023/6/27.
//

class PopupModel: NSObject {
    
    /// 弹窗对象
    var popupObj: PopupProtocol
    /// 弹窗配置
    var config: PopupConfigure {
        willSet {
            if let duration = config.dismissDuration, duration > 0 {
                dismissTime = duration
            }
        }
    }
    /// 弹窗背景
    var bgView: PopupBackgroundView
    /// 内容视图
    var contentView: UIView { popupObj.supplyCustomPopupView() }
    /// 初始尺寸
    var originalFrame: CGRect?
    /// 定时器
    var timer: Timer?
    /// 消失时间
    var dismissTime: TimeInterval?
    
    init(popupObj: PopupProtocol,
         config: PopupConfigure,
         bgView: PopupBackgroundView) {
        self.popupObj = popupObj
        self.config = config
        self.bgView = bgView
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}

// MARK: - UI相关
extension PopupModel {
    
    /// 弹窗是否有效
    func isValidModel() -> Bool {
        if CGSizeEqualToSize(bgView.bounds.size, .zero) {
            return false
        }
        
        return true
    }
    
    /// 给自定义的弹窗内容设置圆角
    func setupCustomViewCorners() {
        bgView.layoutIfNeeded()
        
        // 没有圆角直接返回
        let rectCorners = config.rectCorners
        let cornerRadius = config.cornerRadius
        let isSetCornet = rectCorners.contains(UIRectCorner.topLeft)
        || rectCorners.contains(.topRight)
        || rectCorners.contains(.bottomLeft)
        || rectCorners.contains(.bottomRight)
        || rectCorners.contains(.allCorners)
        
        // 没有圆角直接返回
        guard isSetCornet, (config.rectCorners.rawValue) > 0 else { return }
        var cornerRadiusV = contentView
        if let callback = popupObj.needSetCornerRadiusView,
           let v = callback(),
           !CGSizeEqualToSize(v.bounds.size, .zero),
           comparePopupProtocol(popupObj, popupObj) {
            cornerRadiusV = v
        }
        
        // 没有需要设置的圆角视图直接返回
        let path = UIBezierPath(roundedRect: cornerRadiusV.bounds,
                                byRoundingCorners: rectCorners,
                                cornerRadii: CGSize(width: cornerRadius,
                                                    height: cornerRadius))
        let layer = CAShapeLayer()
        layer.frame = cornerRadiusV.bounds
        layer.path = path.cgPath
        cornerRadiusV.layer.mask = layer
    }
    
}

// MARK: - 定时器相关
extension PopupModel {
    
    func isValidTimer() -> Bool {
        return dismissTime != nil
    }
    
    func startTimer() {
        guard isValidModel() else { return }
        
        timer = Timer.scheduledTimer(timeInterval: 1.0,
                                     target: self,
                                     selector: #selector(timerLoopExecute),
                                     userInfo: nil,
                                     repeats: true)
        
        guard timer != nil else { return }
        RunLoop.main.add(timer!, forMode: .common)
        timer?.fire()
    }
    
    func closeTimer() {
        guard isValidModel() else { return }
        
        timer?.invalidate()
        timer = nil
        dismissTime = config.dismissDuration
    }
    
    @objc func timerLoopExecute() {
        guard isValidModel() else { return }
        
        guard dismissTime! >= 1 else {
            closeTimer()
            PopupManager.shared.dismiss(popup: popupObj)
            return
        }
        
        if let callback = popupObj.countTime {
            callback(dismissTime!)
        }
    }
}

// MARK: - 手势相关
extension PopupModel: UIGestureRecognizerDelegate {
    
    func addGesture() {
        // 背景手势
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapBackground(gesture:)))
        tap.delegate = self
        bgView.addGestureRecognizer(tap)
        
        // 上滑手势
        guard config.isDragClose else { return }
        let pan = UIPanGestureRecognizer(target: self, action: #selector(dragTipView(gesture:)))
        pan.delegate = self
        bgView.addGestureRecognizer(pan)
    }
    
    /// 点击背景回调
    @objc func tapBackground(gesture: UIGestureRecognizer) {
        guard config.isClickDismiss else { return }
        
        bgView.endEditing(true)
        PopupManager.shared.dismiss(popup: popupObj)
    }
    
    /// 上滑Tip弹窗
    @objc func dragTipView(gesture: UIPanGestureRecognizer) {
        // 获取手指偏移量
        guard let originFrame = originalFrame else { return }
        
        let translation = gesture.translation(in: contentView)
        
        if translation.y < 0 {
            let offY = originFrame.origin.y + originFrame.size.height / 2 - abs(translation.y)
            contentView.layer.position = CGPoint(x: contentView.layer.position.x,
                                              y: offY)
        } else {
            contentView.frame = originFrame
        }
        
        if gesture.state == .ended {
            if abs(translation.y) >= originFrame.size.height / 2 {
                PopupManager.shared.dismiss(popup: popupObj)
            } else {
                contentView.frame = originFrame
            }
        }
    }
    
    /// UIGestureRecognizerDelegate协议
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if (touch.view?.isDescendant(of: contentView) ?? false),
           config.sceneStyle != .top {
            return false
        }
        return true
    }
}

// MARK: - 键盘相关
extension PopupModel {
    
    func addKeyboardMonitor() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(noti:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardDidShow(noti:)),
                                               name: UIResponder.keyboardDidShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(noti:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardDidHide(noti:)),
                                               name: UIResponder.keyboardDidHideNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillChangeFrame(noti:)),
                                               name: UIResponder.keyboardWillChangeFrameNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardDidChangeFrame(noti:)),
                                               name: UIResponder.keyboardDidChangeFrameNotification,
                                               object: nil)
    }
    
    @objc func keyboardWillShow(noti: Notification) {
        config.keyboardWillShowCallback?()
        
        guard let duration = noti.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval,
              let endFrame = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        // 键盘y值
        let maxY = endFrame.origin.y
        // 弹窗左上角
        let popVPoint = contentView.layer.position
        let curMaxY = popVPoint.y + contentView.frame.size.height / 2
        // 偏移量
        let offY = curMaxY - maxY + config.keyboardVSpace
        
        // 键盘被遮挡时执行动画
        if maxY < curMaxY {
            let originPoint = contentView.layer.position
            UIView.animate(withDuration: duration) {
                self.contentView.layer.position = CGPoint(x: originPoint.x,
                                                          y: originPoint.y - offY)
            }
        }
    }
    
    @objc func keyboardDidShow(noti: Notification) {
        config.keyboardDidShowCallback?()
    }
    
    @objc func keyboardWillHide(noti: Notification) {
        config.keyboardWillHideCallback?()
        
        guard let duration = noti.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else { return }
        UIView.animate(withDuration: duration) {
            self.contentView.frame = self.originalFrame ?? .zero
        }
    }
    
    @objc func keyboardDidHide(noti: Notification) {
        config.keyboardDidHideCallback?()
    }
    
    @objc func keyboardWillChangeFrame(noti: Notification) {
        guard let callback = config.keyboardFrameWillChange,
              let userInfo = noti.userInfo else { return }
        
        handleCallback(userInfo: userInfo, callback: callback)
    }
    
    @objc func keyboardDidChangeFrame(noti: Notification) {
        guard let callback = config.keyboardFrameDidChange,
              let userInfo = noti.userInfo else { return }
        
        handleCallback(userInfo: userInfo, callback: callback)
    }
    
    func handleCallback(userInfo: [AnyHashable : Any], callback: FrameCallback) {
        if let beginFrame = userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? CGRect,
           let endFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
           let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval {
            callback(beginFrame, endFrame, duration)
        }
    }
}
