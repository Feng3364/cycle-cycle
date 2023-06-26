//
//  PopupProtocol.swift
//  XFlash
//
//  Created by Felix on 2023/6/26.
//

@objc protocol PopupProtocol {
    /// 提供一个弹窗view对象
    func supplyCustomPopupView() -> UIView
    
    /// 对自定义view进行布局
    @objc func layout(with superV: UIView)
    
    /// 执行自定义动画
    @objc func executeCustomAnimation()
    
    /// 提供一个需要设置圆角的view
    @objc func needSetCornerRadiusView() -> UIView
    
    /// 倒计时剩余时间回调
    @objc func countTime(with count: Int)
    
    /// 弹窗生命周期
    @objc func popupViewDidAppear()
    @objc func popupViewDidDisappear()
}
