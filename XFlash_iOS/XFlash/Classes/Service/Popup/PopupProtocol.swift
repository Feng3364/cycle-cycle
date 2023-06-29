//
//  PopupProtocol.swift
//  XFlash
//
//  Created by Felix on 2023/6/26.
//

@objc
public protocol PopupProtocol {
    /// 提供一个弹窗view对象
    func supplyCustomPopupView() -> UIView
    
    /// 对自定义view进行布局
    @objc optional func layout(with superV: UIView)
    
    /// 执行自定义动画
    @objc optional func executeCustomAnimation()
    
    /// 提供一个需要设置圆角的view
    @objc optional func needSetCornerRadiusView() -> UIView?
    
    /// 倒计时剩余时间回调
    @objc optional func countTime(with count: TimeInterval)
    
    /// 弹窗生命周期
    @objc optional func popupViewDidAppear()
    @objc optional func popupViewDidDisappear()
}
