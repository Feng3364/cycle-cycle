//
//  PopupServiceVC.swift
//  XFlash_Example
//
//  Created by Felix on 2023/6/29.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import UIKit
import XFlash

private extension StringKey {
    static let single = "单一"
    static let oc = "OC"
    static let keyboard = "键盘"
    static let configure = "配置"
    static let animate = "动画"
    static let combine = "组合"
    static let remove = "移除"
    static let toast = "Toast"
    
    static let top = "top"
    static let center = "center"
    static let bottom = "bottom"
    static let full = "full"
    static let popup = "弹出风格"
    static let dismiss = "消失风格"
    static let duration = "持续时长"
    static let popupDuration = "弹出动画时长"
    static let dismissDuration = "消失动画时长"
    static let hideBackground = "隐藏/不隐藏背景"
    static let backgroundColor = "随机背景颜色"
    static let backgroundAlpha = "随机背景透明度"
    static let radius = "随机圆角大小"
    static let keyboardSpace = "随机键盘间距"
    static let centerToCenter = "center->center"
    static let topToTop = "top->top"
    static let bottomToBottom = "bottom->bottom"
    static let fullToFull = "full->full"
    static let centerToTop = "center->top"
    static let centerToBottom = "center->bottom"
    static let aloneMode = "配置aloneMode"
    static let terminatorMode = "配置terminatorMode"
    static let removeByIdentifier = "根据identifier移除"
    static let removeByGroupId = "根据groupId移除"
    static let removeByContainer = "根据container移除"
    static let removeAll = "移除all"
    
    static let toastNull = "Toast提示空视图"
    static let toastSingle = "单个Toast提示"
    static let toastMulit = "多个Toast提示叠加"
    static let toastLoading = "展示转圈toast"
    static let toastHide = "隐藏转圈toast"
}

class PopupServiceVC: BaseTableVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        resetData(with: [
            (title: StringKey.single,
             list: [
                StringKey.top,
                StringKey.center,
                StringKey.bottom,
                StringKey.full,
            ]),
            (title: StringKey.oc,
             list: [
                StringKey.top,
                StringKey.center,
                StringKey.bottom,
                StringKey.full,
            ]),
            (title: StringKey.keyboard,
             list: [
                StringKey.keyboard,
            ]),
            (title: StringKey.animate,
             list: [
                StringKey.popup,
                StringKey.dismiss,
                StringKey.duration,
                StringKey.popupDuration,
                StringKey.dismissDuration,
            ]),
            (title: StringKey.configure,
             list: [
                StringKey.hideBackground,
                StringKey.backgroundColor,
                StringKey.backgroundAlpha,
                StringKey.radius,
                StringKey.keyboardSpace,
            ]),
            (title: StringKey.combine,
             list: [
                StringKey.centerToCenter,
                StringKey.topToTop,
                StringKey.bottomToBottom,
                StringKey.fullToFull,
                StringKey.centerToTop,
                StringKey.centerToBottom,
            ]),
            (title: StringKey.remove,
             list: [
                StringKey.aloneMode,
                StringKey.terminatorMode,
                StringKey.removeByIdentifier,
                StringKey.removeByGroupId,
                StringKey.removeByContainer,
                StringKey.removeAll,
            ]),
            (title: StringKey.toast,
             list: [
                StringKey.toastNull,
                StringKey.toastSingle,
                StringKey.toastMulit,
                StringKey.toastLoading,
                StringKey.toastHide,
            ]),
        ])
    }
    
}

// MARK: - UITableViewDelegate
extension PopupServiceVC {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        super.tableView(tableView, didSelectRowAt: indexPath)
        
        let condition = dataArray[indexPath.section].title
        let title = dataArray[indexPath.section].list[indexPath.row]
        switch condition {
        case StringKey.single:
            handleSingleCondition(title)
        case StringKey.oc:
            handleObjectiveCondition(title)
        case StringKey.keyboard:
            handleKeyboardCondition(title)
        case StringKey.animate:
            handleAnimateCondition(title)
        case StringKey.configure:
            handleConfigureCondition(title)
        case StringKey.combine:
            handleCombineCondition(title)
        case StringKey.remove:
            handleGroupCondition(title)
        case StringKey.toast:
            handleToastCondition(title)
        default:
            break
        }
    }
    
}

// MARK: - 不同场景
extension PopupServiceVC {

    func handleSingleCondition(_ title: String) {
        var scene = PopupScene.center
        switch title {
        case StringKey.top:
            scene = .top
        case StringKey.center:
            scene = .center
        case StringKey.bottom:
            scene = .bottom
        case StringKey.full:
            scene = .full
        default:
            break
        }
        popupView(scene: scene)
    }
    
    func handleObjectiveCondition(_ title: String) {
        var scene = PopupScene.center
        switch title {
        case StringKey.top:
            scene = .top
        case StringKey.center:
            scene = .center
        case StringKey.bottom:
            scene = .bottom
        case StringKey.full:
            scene = .full
        default:
            break
        }
        popupView(scene: scene, view: OCPopupView(frame: .zero))
    }
    
    func handleKeyboardCondition(_ title: String) {
        popupView(view: PopupInputView())
    }
    
    func handleAnimateCondition(_ title: String) {
        var config = PopupConfigure()
        switch title {
        case StringKey.popup:
            let popStyle = Int(arc4random() % 5)
            if popStyle == 0 {
                config.popStyle = .fall
            } else if popStyle == 1 {
                config.popStyle = .fall
            } else if popStyle == 2 {
                config.popStyle = .rise
            } else if popStyle == 3 {
                config.popStyle = .scale
            }
            config.popAnimationDuration = 1
            print("当前弹出风格为\(config.popStyle)")
        case StringKey.dismiss:
            let popStyle = Int(arc4random() % 2)
            if popStyle == 0 {
                config.dismissStyle = .fade
            } else if popStyle == 1 {
                config.dismissStyle = .none
            }
            config.dismissAnimationDuration = 1
            print("当前消失风格为\(config.dismissStyle)")
        case StringKey.duration:
            let dismissDuration = TimeInterval(arc4random() % 5)
            config.dismissDuration = dismissDuration
            print("当前持续时长为\(dismissDuration)")
        case StringKey.popupDuration:
            let popAnimationDuration = TimeInterval(arc4random() % 5)
            print("当前弹出动画时长为\(popAnimationDuration)")
            config.popAnimationDuration = popAnimationDuration
        case StringKey.dismissDuration:
            let dismissAnimationDuration = TimeInterval(arc4random() % 5)
            print("当前消失动画时长为\(dismissAnimationDuration)")
            config.dismissAnimationDuration = dismissAnimationDuration
        default:
            break
        }
        popupView(config: config)
    }
    
    func handleConfigureCondition(_ title: String) {
        var config = PopupConfigure()
        switch title {
        case StringKey.hideBackground:
            let isHiddenBackgroundView = Int(arc4random() % 2)
            print("当前隐藏背景状态为\(isHiddenBackgroundView)")
            config.isHiddenBackgroundView = isHiddenBackgroundView == 1
        case StringKey.backgroundColor:
            let red = CGFloat(arc4random() % 255) / 255
            let green = CGFloat(arc4random() % 255) / 255
            let blue = CGFloat(arc4random() % 255) / 255
            print("当前背景颜色为red:\(red)-green:\(green)-blue:\(blue)")
            config.backgroundColor = UIColor(red: red,
                                             green: green,
                                             blue: blue,
                                             alpha: 1)
        case StringKey.backgroundAlpha:
            let alpha = CGFloat(arc4random() % 100) / 100
            print("当前背景透明度\(alpha)")
            config.backgroundAlpha = alpha
        case StringKey.radius:
            let rectCorners = UIRectCorner(rawValue: UInt(arc4random() % 4))
            let cornerRadius = CGFloat(arc4random() % 10) + 5
            print("当前圆角为状态\(rectCorners.rawValue)-圆角大小\(cornerRadius)")
            config.rectCorners = rectCorners
            config.cornerRadius = cornerRadius
        case StringKey.keyboardSpace:
            let keyboardVSpace = Double(arc4random() % 50)
            print("当前键盘间距为\(keyboardVSpace)")
            config.keyboardVSpace = keyboardVSpace
            popupView(config: config, view: PopupInputView())
            return
        default:
            break
        }
        popupView(config: config)
    }
    
    func handleCombineCondition(_ title: String) {
        switch title {
        case StringKey.centerToCenter:
            popupView(scene: .center)
            popupView(scene: .center)
        case StringKey.topToTop:
            popupView(scene: .top)
            popupView(scene: .top)
        case StringKey.bottomToBottom:
            popupView(scene: .bottom)
            popupView(scene: .bottom)
        case StringKey.fullToFull:
            popupView(scene: .full)
            popupView(scene: .full)
        case StringKey.centerToTop:
            popupView(scene: .center)
            popupView(scene: .top)
        case StringKey.centerToBottom:
            popupView(scene: .center)
            popupView(scene: .bottom)
        default:
            break
        }
    }
    
    func handleGroupCondition(_ title: String) {
        switch title {
        case StringKey.aloneMode:
            dismiss(aloneMode: true)
        case StringKey.terminatorMode:
            dismiss(terminatorMode: true)
        case StringKey.removeByIdentifier:
            dismiss(identifier: "id_1")
        case StringKey.removeByGroupId:
            dismiss(groupId: "group_1")
        case StringKey.removeByContainer:
            dismiss(container: view)
        case StringKey.removeAll:
            dismiss()
        default:
            break
        }
    }
}

// MARK: - 不同弹窗
extension PopupServiceVC {
    
    func popupView(scene: PopupScene = .center,
                   config: PopupConfigure? = nil,
                   view: PopupProtocol? = nil) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
            var defaultConfig = PopupConfigure()
            defaultConfig.sceneStyle = scene
            defaultConfig.isClickDismiss = true
            defaultConfig.cornerRadius = 8
            defaultConfig.popStyle = .scale
            defaultConfig.priority = 80
            
            PopupManager.shared.add(popup: view ?? PopupView(type: scene),
                                    options: config ?? defaultConfig)
        }
    }
    
    func dismiss(aloneMode: Bool = false,
                 terminatorMode: Bool = false,
                 identifier: String? = nil,
                 groupId: String? = nil,
                 container: UIView? = nil) {
        var config1 = PopupConfigure()
        config1.identifier = "id_1"
        config1.groupId = "group_1"
        config1.superView = view
        popupView(config: config1)
        
        // 与config1 同一组、同一containerView
        var config2 = PopupConfigure()
        config2.identifier = "id_2"
        config2.groupId = "group_1"
        config2.superView = view
        popupView(config: config2)
        
        var config3 = PopupConfigure()
        // 会清空同组or全部config
        config3.isAloneMode = aloneMode
        config3.isTerminatorMode = terminatorMode
        config3.identifier = "id_3"
        config3.groupId = "group_1"
        config3.superView = UIApplication.shared.keyWindow!
        popupView(config: config3)
        
        guard !aloneMode, !terminatorMode else { return }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            if let identifier = identifier {
                PopupManager.shared.dismiss(identifier: identifier)
            } else if let groupId = groupId {
                PopupManager.shared.dismiss(groupId: groupId)
            } else if let container = container {
                PopupManager.shared.removeAllPopup(from: container)
            } else {
                PopupManager.shared.removeAllPopup()
            }
        }
    }
}

// MARK: - Toast
extension PopupServiceVC {
    
    func handleToastCondition(_ title: String) {
        switch title {
        case StringKey.toastNull:
            showToast(nil)
        case StringKey.toastSingle:
            showToast("你好")
        case StringKey.toastMulit:
            showToast("你好")
            showToast("Hello World")
        case StringKey.toastLoading:
            showLoading()
        case StringKey.toastHide:
            hideLoading()
        default:
            break
        }
    }
}
