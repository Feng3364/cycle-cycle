//
//  PopupConfigure.swift
//  XFlash
//
//  Created by Felix on 2023/6/26.
//

// MARK: - typealias

public typealias FrameCallback = ((CGRect, CGRect, TimeInterval) -> Void)
public typealias PopupCallback = (() -> Void)

// MARK: - Enum

/// 弹窗风格
public enum PopupScene {
    /// 中心弹窗
    case center
    /// 顶部tip
    case top
    /// 底部弹窗
    case bottom
    /// 全屏弹窗
    case full
}

/// 弹出动画
public enum PopAnimationStyle {
    /// 渐变
    case fade
    /// 顶部落下（PopupScene.center时生效）
    case fall
    /// 底部升起（PopupScene.bottom时生效）
    case rise
    /// 比例动画
    case scale
}

/// 消失动画
public enum DismissAnimationStyle {
    /// 渐变
    case fade
    /// 无
    case none
}

// MARK: - Configure
public struct PopupConfigure {
    
    // MARK: - 标识相关
    /// 弹窗唯一标识
    public var identifier: String
    /// 分组id
    public var groupId: String?
    /// 是否添加之前清空同组弹窗（默认为false）
    public var isAloneMode: Bool
    /// 是否添加之前清空所有弹窗（默认为false）
    public var isTerminatorMode: Bool
    
    // MARK: - UI相关
    /// 是否隐藏背景
    public var isHiddenBackgroundView: Bool
    /// 背景颜色（默认为半透明黑色）
    public var backgroundColor: UIColor
    /// 背景透明度
    public var backgroundAlpha: CGFloat
    /// 圆角方向
    public var rectCorners: UIRectCorner
    /// 圆角大小
    public var cornerRadius: Double
    /// 键盘和弹窗间距（默认为10，底部弹窗为0）
    public var keyboardVSpace: Double
    
    // MARK: - 操作相关
    /// 优先级（0~1000）
    public var priority: Int
    /// 弹窗容器
    public var superView: UIView?
    public var containerView: UIView {
        superView ?? UIApplication.shared.keyWindow ?? UIView()
    }
    /// 是否点击弹窗背景（空白区域）消失
    public var isClickDismiss: Bool
    /// 顶部通知条是否支持上滑关闭（默认YES）
    public var isDragClose: Bool
    
    // MARK: - 动画相关
    /// 弹窗风格
    public var sceneStyle: PopupScene
    /// 弹出风格
    public var popStyle: PopAnimationStyle
    /// 消失风格
    public var dismissStyle: DismissAnimationStyle
    /// 持续时长（不设置则不消失）
    public var dismissDuration: TimeInterval?
    /// 弹出动画时长
    public var popAnimationDuration: TimeInterval
    /// 消失动画时长
    public var dismissAnimationDuration: TimeInterval
    
    // MARK: - 回调相关
    /// 点击空白区域回调
    public var clickBgCallback: PopupCallback?
    /// 弹窗生命周期回调
    public var popViewDidShowCallback: PopupCallback?
    public var popViewDidDismissCallback: PopupCallback?
    /// 键盘弹出/隐藏回调
    public var keyboardWillShowCallback: PopupCallback?
    public var keyboardDidShowCallback: PopupCallback?
    public var keyboardWillHideCallback: PopupCallback?
    public var keyboardDidHideCallback: PopupCallback?
    /// 键盘大小改变回调
    public var keyboardFrameWillChange: FrameCallback?
    public var keyboardFrameDidChange: FrameCallback?
    
    public init() {
        // 标识
        identifier = ""
        groupId = nil
        isAloneMode = false
        isTerminatorMode = false
        
        // UI
        isHiddenBackgroundView = false
        backgroundColor = .black
        backgroundAlpha = 0.25
        rectCorners = []
        cornerRadius = 0
        keyboardVSpace = 10
        
        // 操作
        priority = 0
        superView = nil
        isClickDismiss = false
        isDragClose = false
        
        // 动画
        sceneStyle = .center
        popStyle = .fade
        dismissStyle = .fade
        dismissDuration = nil
        popAnimationDuration = 0.3
        dismissAnimationDuration = 0.3
    }
}

// MARK: - 配置操作
extension PopupConfigure {
    
    mutating func setDefaultConfigure() {
        if cornerRadius > 0, rectCorners == [] {
            rectCorners = .allCorners
        }
        
        // 顶部tip默认独立分组
        if sceneStyle == .top, groupId == nil {
            groupId = "PopupSceneForTop"
            isHiddenBackgroundView = true
        }
        
        // 顶部tip默认上滑关闭
        if sceneStyle == .top {
            isDragClose = true
            isClickDismiss = false
        }
        
        // 底部弹窗设置键盘间距
        if sceneStyle == .bottom {
            keyboardVSpace = 0
        }
    }
    
    mutating func setAnimationDuration(forPop: TimeInterval) {
        if forPop > 0, forPop < 3 {
            popAnimationDuration = forPop
        }
    }
    
    mutating func setAnimationDuration(forDismiss: TimeInterval) {
        if forDismiss > 0, forDismiss < 3 {
            dismissAnimationDuration = forDismiss
        }
    }
    
}
