//
//  PopupManager.swift
//  XFlash
//
//  Created by Felix on 2023/6/26.
//

public class PopupManager {
    
    // MARK: - Variable
    
    private var windowQueue: [PopupModel]
    
    // MARK: - 单例
    public static let shared = PopupManager()
    
    private init() {
        windowQueue = []
    }
}

// MARK: - Public
public extension PopupManager {
    
    /// 增加弹窗
    /// - Parameters:
    ///   - popup: 遵守协议的弹窗
    ///   - priority: 优先级
    ///   - options: 配置项
    func add(popup: PopupProtocol,
             priority: Int = 0,
             options: PopupConfigure? = nil) {
        guard checkMainThread() else { return }
        
        // 配置项
        var config: PopupConfigure
        if let options = options {
            config = options
        } else {
            config = PopupConfigure()
        }
        config.priority = priority
        config.setDefaultConfigure()
        config.superView = curContainerView(config.containerView)
        
        // 弹窗背景视图
        var popupFrame = config.containerView.bounds
        if (CGSizeEqualToSize(popupFrame.size, .zero)) {
            let size = UIScreen.main.bounds.size
            popupFrame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        }
        let bgView = PopupBackgroundView(frame: popupFrame)
        bgView.backgroundColor = config.backgroundColor
        bgView.hiddenBg = config.isHiddenBackgroundView
        
        // 弹窗模型
        let model = PopupModel(popupObj: popup,
                               config: config,
                               bgView: bgView)
        model.bgView.addSubview(popup.supplyCustomPopupView())
        model.addGesture()
        model.addKeyboardMonitor()
        pop(with: model, isRecover: false)
    }
    
    /// 移除指定弹窗
    /// - Parameters:
    ///   - popup: 遵守协议的弹窗
    ///   - identifier: 弹窗唯一标识
    func dismiss(popup: PopupProtocol? = nil,
                 identifier: String? = nil) {
        guard checkMainThread() else { return }
        
        if let popup = popup, let model = getPopupBy(popup: popup) {
            dismiss(with: model, isRemoveQueue: true)
        }
        
        if let id = identifier, !id.isEmpty, let model = getPopupWith(identifier: id) {
            dismiss(with: model, isRemoveQueue: true)
        }
    }
    
    /// 移除所有弹窗
    func removeAllPopup() {
        guard checkMainThread() else { return }
        
        var pendingList: [(index: Int, model: PopupModel)] = []
        for indexE in windowQueue.enumerated() {
            // 剔除Tip类型
            if indexE.element.config.sceneStyle != .top {
                pendingList.append((index: indexE.offset, model: indexE.element))
            }
        }
        
        while pendingList.count > 0 {
            let indexE = pendingList.last!
            if let callback = indexE.model.popupObj.popupViewDidDisappear {
                callback()
            }
            indexE.model.bgView.removeFromSuperview()
            
            windowQueue.remove(at: indexE.index)
            pendingList.removeLast()
        }
    }
    
    /// 移除指定视图上所有弹窗
    func removeAllPopup(from container: UIView?) {
        guard checkMainThread() else { return }
        
        let aimView = curContainerView(container)
        
        var pendingList = getPopupsIn(container: aimView)
        guard !pendingList.isEmpty else { return }
        
        while pendingList.count > 0 {
            let model = pendingList.last!
            if let callback = model.popupObj.popupViewDidDisappear {
                callback()
            }
            model.bgView.removeFromSuperview()
            
            windowQueue.removeAll { $0 == model }
            pendingList.removeLast()
        }
    }
    
    /// 获取所有弹窗个数
    func getAllPopupCount() -> Int {
        guard checkMainThread() else { return 0 }
        return windowQueue.count
    }
    
    /// 获取弹窗个数
    /// - Parameter container: 指定视图
    /// - Returns: 弹窗个数
    func getPopupCount(with container: UIView? = nil) -> Int {
        guard checkMainThread() else { return 0 }
        
        let containerV = curContainerView(container)
        return PopupManager.shared.getPopupsIn(container: containerV).count
    }
}

// MARK: - Pop
private extension PopupManager {
    
    func pop(with model: PopupModel, isRecover: Bool) {
        guard checkMainThread() else { return }
        
        let clearBlock: (([PopupModel]) -> Void) = { list in
            guard !list.isEmpty else { return }
            
            var list = list
            while list.count > 0 {
                self.dismiss(with: list.last!, isRemoveQueue: true)
                list.remove(at: list.count - 1)
            }
        }
        
        // Alone模式把同一Group的弹窗移除
        if model.config.isAloneMode {
            let popupList = getPopupsWith(groupId: model.config.groupId)
            clearBlock(popupList)
        }
        
        // Terminator模式把所有弹窗移除
        if model.config.isTerminatorMode {
            clearBlock(windowQueue)
        } else {
            // 根据优先级叠加展示
            let allPopupList = getPopupsWith(groupId: model.config.groupId)
            if allPopupList.count > 0, !isRecover {
                let last = allPopupList.last!
                
                if model.config.priority >= last.config.priority {
                    last.bgView.endEditing(true)
                    dismiss(with: last, isRemoveQueue: false)
                } else {
                    // 入队列等待展示
                    enterQueue(with: model)
                    return
                }
            }
        }
        
        if model.bgView.superview == nil {
            model.config.containerView.addSubview(model.bgView)
            model.config.containerView.bringSubviewToFront(model.bgView)
        }
        
        // 弹窗内容自定义布局
        if let callback = model.popupObj.layout {
            callback(model.bgView)
        }
        //获取到业务中ContentView的frame
        model.bgView.layoutIfNeeded()
        //缓存弹窗内容的原始frame
        model.originalFrame = model.contentView.frame
        
        // 开启定时器
        if (model.config.dismissDuration ?? 0) >= 1 {
            model.startTimer()
        }
        
        // pop动画
        popAnimate(with: model, needAnimation: true)
        
        // 入队
        if !isRecover {
            enterQueue(with: model)
        }
        
        // 配置圆角
        model.setupCustomViewCorners()
        
        // 回调
        model.config.popViewDidShowCallback?()
        if let callback = model.popupObj.popupViewDidAppear {
            callback()
        }
    }
    
    func popAnimate(with model: PopupModel, needAnimation: Bool) {
        guard checkMainThread() else { return }
        
        // 不需要动画时基础渐隐
        guard needAnimation else {
            alphaChange(with: model, isPop: true)
            return
        }
        
        // 自定义动画时回调
        if let callback = model.popupObj.executeCustomAnimation {
            alphaChange(with: model, isPop: true)
            callback()
            return
        }
        
        // 执行背景动画
        model.bgView.backgroundColor = drawBackgroundView(with: model, color: model.config.backgroundColor, alpha: 0)
        model.contentView.alpha = 1
        UIView.animate(withDuration: model.config.popAnimationDuration) {
            model.bgView.backgroundColor = self.drawBackgroundView(with: model, color: model.config.backgroundColor, alpha: model.config.backgroundAlpha)
        }
        
        let popSize = model.originalFrame?.size ?? .zero
        let originPoint = model.originalFrame?.origin ?? .zero
        let startPosition = CGPoint(x: originPoint.x + popSize.width / 2,
                                    y: originPoint.y + popSize.height / 2)
        let sceneStyle = model.config.sceneStyle
        switch sceneStyle {
        case .center:
            handlePopAnimation(with: model)
        case .top:
            let contentV = model.contentView
            contentV.layer.position = CGPoint(x: contentV.layer.position.x,
                                              y: -((model.originalFrame?.size.height ?? 0) * 0.5))
            UIView.animate(withDuration: model.config.popAnimationDuration,
                           delay: 0,
                           usingSpringWithDamping: 1,
                           initialSpringVelocity: 1.0,
                           options: .curveEaseOut) {
                contentV.layer.position = startPosition
            }
        case .bottom:
            let contentV = model.contentView
            contentV.layer.position = CGPoint(x: contentV.layer.position.x,
                                              y: CGRectGetMaxY(model.bgView.frame) + ((model.originalFrame?.size.height ?? 0) * 0.5))
            UIView.animate(withDuration: model.config.popAnimationDuration,
                           delay: 0,
                           usingSpringWithDamping: 1,
                           initialSpringVelocity: 1.0,
                           options: .curveEaseOut) {
                contentV.layer.position = startPosition
            }
        default:
            break
        }
    }
    
    func handlePopAnimation(with model: PopupModel) {
        let contentView = model.contentView
        
        let startPosition = contentView.layer.position
        let popAnimationType = model.config.popStyle
        switch popAnimationType {
        case .fade:
            alphaChange(with: model, isPop: true)
        case .fall:
            contentView.layer.position = CGPoint(x: contentView.layer.position.x,
                                                 y: CGRectGetMidY(model.bgView.frame) - (model.originalFrame?.size.height ?? 0) * 0.5)
        case .rise:
            contentView.layer.position = CGPoint(x: contentView.layer.position.x,
                                                 y: CGRectGetMidY(model.bgView.frame) + (model.originalFrame?.size.height ?? 0) * 0.5)
        case .scale:
            alphaChange(with: model, isPop: true)
            animate(with: contentView.layer,
                    duration: model.config.popAnimationDuration,
                    values: [0.0, 1.2, 1.0])
        }
        
        guard popAnimationType == .fall || popAnimationType == .rise else { return }
        UIView.animate(withDuration: model.config.popAnimationDuration,
                       delay: 0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 0,
                       options: .curveEaseOut) {
            contentView.layer.position = startPosition
        }
    }
    
    func animate(with layer: CALayer, duration: TimeInterval, values: [NSNumber]) {
        let popAnimation = CAKeyframeAnimation(keyPath: "transform")
        popAnimation.duration = duration
        popAnimation.keyTimes = values
        popAnimation.values = [
            NSValue(caTransform3D: CATransform3DMakeScale(1.1, 1.1, 1.0)),
            NSValue(caTransform3D: CATransform3DIdentity),
        ]
        popAnimation.timingFunctions = [
            CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut),
            CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        ]
        layer.add(popAnimation, forKey: nil)
    }
    
    func alphaChange(with model: PopupModel, isPop: Bool) {
        let bgView = model.bgView
        
        if isPop {
            bgView.backgroundColor = drawBackgroundView(with: model, color: model.config.backgroundColor, alpha: 0)
            model.contentView.alpha = 0
            
            UIView.animate(withDuration: model.config.popAnimationDuration) {
                bgView.backgroundColor = self.drawBackgroundView(with: model, color: model.config.backgroundColor, alpha: model.config.backgroundAlpha)
                model.contentView.alpha = 1
            }
        } else {
            UIView.animate(withDuration: model.config.dismissAnimationDuration) {
                bgView.backgroundColor = self.drawBackgroundView(with: model, color: model.config.backgroundColor, alpha: 0)
            }
        }
    }
}

// MARK: - Dismiss
private extension PopupManager {
    
    func dismiss(with model: PopupModel, isRemoveQueue: Bool) {
        // 存入待移除队列
        if isRemoveQueue {
            handleWaitRemoveQueue(with: model)
        }
        
        let time = DispatchTime(uptimeNanoseconds: UInt64(model.config.dismissAnimationDuration))
        let queueCount = getPopupsWith(groupId: model.config.groupId).count
        if !(model.config.isAloneMode), isRemoveQueue, queueCount >= 1 {
            DispatchQueue.main.asyncAfter(deadline: time) {
                if queueCount >= 1 {
                    // 如果当前移除的弹窗之前还有被覆盖的，则把之前的重新展示出来
                    let all = self.getPopupsWith(groupId: model.config.groupId)
                    let last = all.last!
                    // 开启定时器
                    if (last.config.dismissDuration ?? 0) >= 1 {
                        last.startTimer()
                    }
                    // pop动画
                    self.popAnimate(with: last, needAnimation: true)
                }
            }
        }
        
        // 执行动画
        var needDismissAnimation = true
        if model.config.sceneStyle == .top || model.config.sceneStyle == .center && !isRemoveQueue {
            needDismissAnimation = false
        }
        dismissAnimate(with: model, needAnimation: needDismissAnimation)
        
        if (model.config.dismissDuration ?? 0) > 0 {
            model.closeTimer()
        }
        if isRemoveQueue {
            DispatchQueue.main.asyncAfter(deadline: time) {
                // 将要关闭
                model.config.popViewDidDismissCallback?()
                if let callback = model.popupObj.popupViewDidDisappear {
                    callback()
                }
                model.closeTimer()
                model.bgView.removeFromSuperview()
            }
        }
    }
    
    func dismissAnimate(with model: PopupModel, needAnimation: Bool) {
        alphaChange(with: model, isPop: false)
        
        guard needAnimation else { return }
        
        let contentV = model.contentView
        switch model.config.sceneStyle {
        case .top:
            UIView.animate(withDuration: model.config.dismissAnimationDuration) {
                contentV.layer.position = CGPoint(x: contentV.layer.position.x,
                                                  y: -((model.originalFrame?.size.height ?? 0)*0.5))
            }
        case .bottom:
            UIView.animate(withDuration: model.config.dismissAnimationDuration) {
                contentV.layer.position = CGPoint(x: contentV.layer.position.x,
                                                  y: CGRectGetMaxY(model.bgView.frame) + (model.originalFrame?.size.height ?? 0) * 0.5)
            }
        default:
            break
        }
    }
}

// MARK: - Helper
private extension PopupManager {
    
    /// 获取【指定groupId】的弹窗数组
    /// - Parameters:
    ///   - groupId: 指定分组标识
    ///   - popupList: 指定弹窗数组（默认为全部弹窗）
    /// - Returns: 弹窗数组
    func getPopupsWith(groupId: String?,
                       popupList: [PopupModel] = shared.windowQueue) -> [PopupModel] {
        guard popupList.count >= 1 else { return [] }
        
        var resultList: [PopupModel] = []
        for item in popupList {
            // 没有设置分组，即为同一默认组
            if item.config.groupId == nil, groupId == nil {
                resultList.append(item)
                continue
            }
            if item.config.groupId == groupId {
                resultList.append(item)
                continue
            }
        }
        return resultList
    }
    
    /// 获取【指定容器】的弹窗数组
    func getPopupsIn(container: UIView) -> [PopupModel] {
        var resultList: [PopupModel] = []
        for item in windowQueue {
            if item.config.containerView == container {
                resultList.append(item)
            }
        }
        return resultList
    }
    
    /// 获取【同一容器】【相同groupId】的弹窗数组
    func getSameGroupPopups(model: PopupModel) -> [PopupModel] {
        let allPops = getPopupsIn(container: (model.config.containerView))
        return getPopupsWith(groupId: model.config.groupId, popupList: allPops)
    }
    
    /// 根据弹窗获取队列中对应的弹窗
    func getPopupBy(popup: PopupProtocol) -> PopupModel? {
        for m in windowQueue {
            if comparePopupProtocol(m.popupObj, popup) {
                return m
            }
        }
        return nil
    }
    
    /// 根据id获取队列中对应的弹窗
    func getPopupWith(identifier: String) -> PopupModel? {
        guard !identifier.isEmpty else { return nil }
        
        for m in windowQueue {
            if m.config.identifier == identifier {
                return m
            }
        }
        return nil
    }
    
    /// 加入队列并排序
    func enterQueue(with model: PopupModel) {
        for item in windowQueue {
            if item == model {
                return
            }
        }
        
        windowQueue.append(model)
        guard windowQueue.count >= 2,
              let last = windowQueue.last
        else { return }
        
        // 插入排序进行优先级调整
        let i = windowQueue.count - 1
        var j = i - 1
        while j >= 0, windowQueue[j].config.priority > last.config.priority {
            windowQueue[j+1] = windowQueue[j]
            j -= 1
        }
        windowQueue[j+1] = last
    }
    
    /// 处理待移除队列
    func handleWaitRemoveQueue(with model: PopupModel) {
        let list = getSameGroupPopups(model: model)
        list.forEach { m in
            if comparePopupProtocol(m.popupObj, model.popupObj) {
                windowQueue.removeAll { $0 == model}
            }
        }
    }
    
    func drawBackgroundView(with model: PopupModel, color: UIColor, alpha: CGFloat) -> UIColor {
        guard !(model.bgView.hiddenBg),
              model.config.backgroundColor != .clear
        else { return .clear }
        
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        color.getRed(&red, green: &green, blue: &blue, alpha: nil)
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    func checkMainThread() -> Bool {
        let isMainThread = Thread.current.isMainThread
        if !isMainThread {
            print("⚠️请在主线程使用PopupManager弹窗服务")
        }
        return isMainThread
    }
    
    func curContainerView(_ container: UIView? = nil) -> UIView {
        return container ?? UIApplication.shared.keyWindow ?? UIView()
    }
}
