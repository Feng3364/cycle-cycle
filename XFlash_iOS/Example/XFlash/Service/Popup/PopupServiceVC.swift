//
//  PopupServiceVC.swift
//  XFlash_Example
//
//  Created by Felix on 2023/6/29.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import UIKit
import XFlash

private enum Condition: String {
    case single = "单一"
    case oc = "OC"
    case keyboard = "键盘"
    case configure = "配置"
    case animate = "动画"
    case combine = "组合"
    case remove = "移除"
}

class PopupServiceVC: BaseTableVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        resetData(with: [
            (title: Condition.single.rawValue, list: [
                "top",
                "center",
                "bottom",
                "full"
            ]),
            (title: Condition.oc.rawValue, list: [
                "top",
                "center",
                "bottom",
                "full"
            ]),
            (title: Condition.keyboard.rawValue, list: [
                "键盘"
            ]),
            (title: Condition.animate.rawValue, list: [
                "弹出风格",
                "消失风格",
                "持续时长",
                "弹出动画时长",
                "消失动画时长"
            ]),
            (title: Condition.configure.rawValue, list: [
                "隐藏/不隐藏背景",
                "随机背景颜色",
                "随机背景透明度",
                "随机圆角",
                "随机键盘间距"
            ]),
            (title: Condition.combine.rawValue, list: [
                "center->center",
                "top->top",
                "bottom->bottom",
                "full->full",
                "center->top",
                "center->bottom",
            ]),
            (title: Condition.remove.rawValue, list: [
                "配置aloneMode",
                "配置terminatorMode",
                "根据identifier移除",
                "根据groupId移除",
                "根据container移除",
                "移除all",
            ]),
        ])
    }
    
}

// MARK: - UITableViewDelegate
extension PopupServiceVC {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        super.tableView(tableView, didSelectRowAt: indexPath)
        let condition = Condition(rawValue: dataArray[indexPath.section].title) ?? .single
        let title = dataArray[indexPath.section].list[indexPath.row]
        switch condition {
        case .single:
            handleSingleCondition(title)
        case .oc:
            handleObjectiveCondition(title)
        case .keyboard:
            handleKeyboardCondition(title)
        case .animate:
            handleAnimateCondition(title)
        case .configure:
            handleConfigureCondition(title)
        case .combine:
            handleCombineCondition(title)
        case .remove:
            handleGroupCondition(title)
        }
    }
    
}

// MARK: - 不同场景
extension PopupServiceVC {

    func handleSingleCondition(_ title: String) {
        var scene = PopupScene.center
        switch title {
        case "top":
            scene = .top
        case "center":
            scene = .center
        case "bottom":
            scene = .bottom
        case "full":
            scene = .full
        default:
            break
        }
        popupView(scene: scene)
    }
    
    func handleObjectiveCondition(_ title: String) {
        var scene = PopupScene.center
        switch title {
        case "top":
            scene = .top
        case "center":
            scene = .center
        case "bottom":
            scene = .bottom
        case "full":
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
        case "弹出风格":
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
        case "消失风格":
            let popStyle = Int(arc4random() % 2)
            if popStyle == 0 {
                config.dismissStyle = .fade
            } else if popStyle == 1 {
                config.dismissStyle = .none
            }
            config.dismissAnimationDuration = 1
            print("当前消失风格为\(config.dismissStyle)")
        case "持续时长":
            let dismissDuration = TimeInterval(arc4random() % 5)
            config.dismissDuration = dismissDuration
            print("当前持续时长为\(dismissDuration)")
        case "弹出动画时长":
            let popAnimationDuration = TimeInterval(arc4random() % 5)
            print("当前弹出动画时长为\(popAnimationDuration)")
            config.popAnimationDuration = popAnimationDuration
        case "消失动画时长":
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
        case "隐藏/不隐藏背景":
            let isHiddenBackgroundView = Int(arc4random() % 2)
            print("当前隐藏背景状态为\(isHiddenBackgroundView)")
            config.isHiddenBackgroundView = isHiddenBackgroundView == 1
        case "随机背景颜色":
            let red = CGFloat(arc4random() % 255) / 255
            let green = CGFloat(arc4random() % 255) / 255
            let blue = CGFloat(arc4random() % 255) / 255
            print("当前背景颜色为red:\(red)-green:\(green)-blue:\(blue)")
            config.backgroundColor = UIColor(red: red,
                                             green: green,
                                             blue: blue,
                                             alpha: 1)
        case "随机背景透明度":
            let alpha = CGFloat(arc4random() % 100) / 100
            print("当前背景透明度\(alpha)")
            config.backgroundAlpha = alpha
        case "随机圆角":
            let rectCorners = UIRectCorner(rawValue: UInt(arc4random() % 4))
            let cornerRadius = CGFloat(arc4random() % 10) + 5
            print("当前圆角为状态\(rectCorners.rawValue)-圆角大小\(cornerRadius)")
            config.rectCorners = rectCorners
            config.cornerRadius = cornerRadius
        case "随机键盘间距":
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
        case "center->center":
            popupView(scene: .center)
            popupView(scene: .center)
        case "top->top":
            popupView(scene: .top)
            popupView(scene: .top)
        case "bottom->bottom":
            popupView(scene: .bottom)
            popupView(scene: .bottom)
        case "full->full":
            popupView(scene: .full)
            popupView(scene: .full)
        case "center->top":
            popupView(scene: .center)
            popupView(scene: .top)
        case "center->bottom":
            popupView(scene: .center)
            popupView(scene: .bottom)
        default:
            break
        }
    }
    
    func handleGroupCondition(_ title: String) {
        switch title {
        case "配置aloneMode":
            dismiss(aloneMode: true)
        case "配置terminatorMode":
            dismiss(terminatorMode: true)
        case "根据identifier移除":
            dismiss(identifier: "id_1")
        case "根据groupId移除":
            // TODO
            dismiss(groupId: "group_1")
        case "根据container移除":
            dismiss(container: view)
        case "移除all":
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
