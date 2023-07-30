//
//  PopupProtocol.swift
//  XFlash
//
//  Created by Felix on 2023/6/26.
//


public typealias FX = XFlash

@objcMembers
public class XFlash: NSObject {
    
    // MARK: - 屏幕尺寸
    
    /// 屏幕坐标
    public static let bounds = UIScreen.main.bounds
    
    /// 屏幕宽
    public static let screenWidth = bounds.width
    
    /// 屏幕高
    public static let screenHeight = bounds.height
    
    /// 状态栏高度
    public static let statusBarHeight = application.statusBarFrame.size.height
    
    /// 导航栏高度
    public static let navBarHeight = CGFloat(44)
    
    /// 顶部导航栏高度
    public static let topHeight = statusBarHeight + navBarHeight
    
    /// 底部安全区域高度
    public static let bottomHeight = application.keyWindow?.safeAreaInsets.bottom ?? 0
    
    /// tabBar高度
    public static let tabBarHeight = CGFloat(49) + bottomHeight
    
    /// 不带tabBar且有导航栏的页面高度（屏幕高-顶部导航栏高度-底部安全区域高度）
    public static let mainHeight = screenHeight - topHeight - bottomHeight
    
    /// 带tabBar且有导航栏的页面高度（屏幕高-顶部导航栏高度-底部安全区域高度）
    public static let mainTabBarHeight = screenHeight - topHeight - tabBarHeight
    
    
    // MARK: - 应用信息
    
    /// 应用名
    public static let displayName = Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String ?? "undefined"
    
    /// 应用标识
    public static let bundleID = Bundle.main.bundleIdentifier ?? "undefined"
    
    /// 应用build
    public static let buildNumber = Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String ?? "1"
    
    /// 应用version
    public static let versionNumber = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    
    /// 是否刘海屏
    public static let iPhoneX = bottomHeight != 0
    
    /// 应用单例
    public static let application = UIApplication.shared
    
    /// 主窗口
    public static var keyWindow: UIWindow? {
        var keyWindow: UIWindow?
        if #available(iOS 13.0, *) {
            keyWindow = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first
        } else {
            keyWindow = UIApplication.shared.keyWindow
        }
        return keyWindow
    }
    
    
    // MARK: - 设备信息
    
    /// 设备名称
    public static let deviceName = UIDevice.current.localizedModel
    
    // 系统版本
    public static let systemVersion = UIDevice.current.systemVersion
    
    /// 设备方向
    public static let deviceOrientation = UIDevice.current.orientation
    
    /// 设备是否水平
    public static var isLandscape: Bool {
        if #available(iOS 13.0, *) {
            return UIApplication.shared.windows
                .first?
                .windowScene?
                .interfaceOrientation
                .isLandscape ?? false
        } else {
            return UIApplication.shared.statusBarOrientation.isLandscape
        }
    }

}
