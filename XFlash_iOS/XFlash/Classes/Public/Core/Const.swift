//
//  PopupProtocol.swift
//  XFlash
//
//  Created by Felix on 2023/6/26.
//


public typealias FX = XFlash

@objcMembers
public class XFlash: NSObject {
    
    // MARK: - 设备信息
    
    /// 设备名称
    public static let deviceName = UIDevice.current.localizedModel
    
    /// 设备方向
    public static let deviceOrientation = UIDevice.current.orientation
    
    /// 设备是否水平
    public static var isLandscape = {
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
    
    
    // MARK: - 屏幕尺寸
    public static let kApplication = UIApplication.shared
    
    /// 屏幕坐标
    public static let bounds = UIScreen.main.bounds
    /// 屏幕宽
    public static let screenWidth = bounds.width
    /// 屏幕高
    public static let screenHeight = bounds.height
    /// 状态栏高度
    public static let statusBarHeight = kApplication.statusBarFrame.size.height
    /// 导航栏高度
    public static let navBarHeight = CGFloat(44)
    /// 顶部导航栏高度
    public static let topHeight = statusBarHeight + navBarHeight
    /// 底部安全区域高度
    public static let bottomHeight = kApplication.keyWindow?.safeAreaInsets.bottom ?? 0
    /// tabBar高度
    public static let tabBarHeight = CGFloat(49) + bottomHeight
    /// 页面高度（屏幕高-顶部导航栏高度-底部安全区域高度）
    public static let mainHeight = screenHeight - topHeight - bottomHeight
    /// 页面高度（屏幕高-顶部导航栏高度-底部安全区域高度）
    public static let mainTabBarHeight = screenHeight - topHeight - tabBarHeight
    
    
    // MARK: - 应用信息
    
    public static let displayName = Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String ?? "undefined"
    
    public static let bundleID = Bundle.main.bundleIdentifier ?? "undefined"
    
    public static let buildNumber = Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String ?? "1"
    
    public static let versionNumber = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    
    
//    public static let shared = SpeedySwift()
//    public static let lock = DispatchSemaphore(value: 1)
//
//    public var openLog = false
//
//    /// 主窗口
//    public static var keyWindow: UIView? {
//        return SS.getKeyWindows()
//    }
//    /// 当前系统版本
//    public static var systemVersion: String {
//        return UIDevice.current.systemVersion
//    }
//    /// 判断设备是不是iPhoneX系列
//    public var isX : Bool {
//        return self.bottomSafeAreaHeight != 0
//    }
//    /// TableBar距底部区域高度
//    public var bottomSafeAreaHeight : CGFloat {
//        return SS.getKeyWindows()?.safeAreaInsets.bottom ?? 0
//    }
//
//    /// 状态栏的高度
//    public var topSafeAreaHeight : CGFloat {
//        return SS.getKeyWindows()?.safeAreaInsets.top ?? 0
//    }
//
//    /// 左边安全距
//    public var leftSafeAreaWidth : CGFloat {
//        return SS.getKeyWindows()?.safeAreaInsets.left ?? 0
//    }
//
//    /// 右边安全距
//    public var rightSafeAreaWidth : CGFloat {
//        return SS.getKeyWindows()?.safeAreaInsets.right ?? 0
//    }
//    public static func getKeyWindows()->UIWindow?{
//        var keyWindow: UIWindow?
//        if #available(iOS 13.0, *) {
//            keyWindow = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first
//        } else {
//            keyWindow = UIApplication.shared.keyWindow
//        }
//        return keyWindow
//    }
//    /// 导航栏的高度
//    public static var navBarHeight: CGFloat {
//        return 44.0
//    }
//
//    /// tabbar的高度
//    public static var tabBarHeight: CGFloat {
//        return 49.0
//    }
//
//    /// 状态栏和导航栏的高度
//    public static var statusWithNavBarHeight : CGFloat {
//        let heigth = SS.shared.topSafeAreaHeight + navBarHeight
//        return heigth
//    }
//    /// 根据宽度缩放
//    public static func scaleW(_ width: CGFloat,fit:CGFloat = 375.0) -> CGFloat {
//        return SS.shared.w / fit * width
//    }
//    /// 根据高度缩放
//    public static func scaleH(_ height: CGFloat,fit:CGFloat = 812.0) -> CGFloat {
//        return SS.shared.h / fit * height
//    }
//    /// 默认根据宽度缩放
//    public static func scale(_ value: CGFloat) -> CGFloat {
//        return scaleW(value)
//    }
//    /// 根据控制器获取 顶层控制器
//    public static func topVC(_ viewController: UIViewController?) -> UIViewController? {
//        guard let currentVC = viewController else {
//            return nil
//        }
//        if let nav = currentVC as? UINavigationController {
//            // 控制器是nav
//            return topVC(nav.visibleViewController)
//        } else if let tabC = currentVC as? UITabBarController {
//            // tabBar 的跟控制器
//            return topVC(tabC.selectedViewController)
//        } else if let presentVC = currentVC.presentedViewController {
//            //modal出来的 控制器
//            return topVC(presentVC)
//        } else {
//            // 返回顶控制器
//            return currentVC
//        }
//    }
//    /// 顶层控制器的navigationController
//    public static var topNavVC: UINavigationController? {
//        if let topVC = self.topVC() {
//            if let nav = topVC.navigationController {
//                return nav
//            } else {
//                return SSNavigationController(rootViewController: topVC)
//            }
//        }
//        return nil
//    }
//    /// 获取顶层控制器 根据window
//    public static func topVC() -> UIViewController? {
//        var window = SS.getKeyWindows()
//        //是否为当前显示的window
//        if window?.windowLevel != UIWindow.Level.normal{
//            let windows = UIApplication.shared.windows
//            for  windowTemp in windows{
//                if windowTemp.windowLevel == UIWindow.Level.normal{
//                    window = windowTemp
//                    break
//                }
//            }
//        }
//        let vc = window?.rootViewController
//        return topVC(vc)
//    }
//    /// window 的 toast
//    public static func toast(message:String,duration: TimeInterval  = 1){
//        if let view = SS.getKeyWindows(){
//            view.toast(message: message,duration: duration)
//        }
//    }
//    /// 当用户截屏时的监听
//    public static func didTakeScreenShot(_ action: @escaping (_ notification: Notification) -> Void) {
//        // http://stackoverflow.com/questions/13484516/ios-detection-of-screenshot
//        _ = NotificationCenter.default.addObserver(forName: UIApplication.userDidTakeScreenshotNotification,
//                                                   object: nil,
//                                                   queue: OperationQueue.main) { notification in
//            action(notification)
//        }
//    }
//    /// 主动崩溃
//    public static func exitApp(){
//        /// 这是默认的程序结束函数,
//        abort()
//    }
}
