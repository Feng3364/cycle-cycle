//
//  AliveThread.swift
//  Pods-XFlash_Example
//
//  Created by Felix on 2023/7/31.
//

import Foundation

public typealias VoidCallback = () -> Void
public class LiveThread: Thread {
    
    deinit {
        print("LiveThread-deinit")
    }
}

@objcMembers
public class AliveThread: NSObject {
    private(set)
    public var liveThread: LiveThread?
    
    var stopped: Bool = false
    var task: VoidCallback?
    
    // MARK: - LifeCycle

    public override init() {
        super.init()
        
        liveThread = LiveThread(block: { [weak self] in
            guard let self = self else { return }
            print("------常驻线程开启-------")
            
            RunLoop.current.add(Port(), forMode: .default)
            while !self.stopped {
                RunLoop.current.run(mode: .default, before: Date.distantFuture)
            }
            
            print("------常驻线程结束-------")
        })
        liveThread?.start()
    }
    
    deinit {
        print("AliveThread-deinit")
    }
}

// MARK: - Public
public extension AliveThread {
    
    func execute(with task: @escaping VoidCallback) {
        guard let liveThread = liveThread else { return }
        
        self.task = task
        perform(#selector(realizeTask),
                on: liveThread,
                with: nil,
                waitUntilDone: false)
    }
    
    func stop() {
        guard let liveThread = liveThread else { return }
        
        perform(#selector(stopLiveThread),
                on: liveThread,
                with: nil,
                waitUntilDone: true)
    }
}


private extension AliveThread {
    
    @objc func realizeTask() {
        guard let task = task else { return }
        task()
    }
    
    @objc func stopLiveThread() {
        stopped = true
        CFRunLoopStop(CFRunLoopGetCurrent())
        liveThread = nil
    }
}
