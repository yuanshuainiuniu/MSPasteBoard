//
//  AppDelegate.swift
//  HttpServer
//
//  Created by Marshal on 2022/7/28.
//

import Cocoa
import ServiceManagement
@main
class AppDelegate: NSObject, NSApplicationDelegate {

    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    let statusMenu =  NSMenu()
    var onMenuItem : NSMenuItem!
    var exMenuItem : NSMenuItem!
    var startOnLaunchItem : NSMenuItem!
    
    var onLine = true
    let startOnLaunchKey = "startOnLaunchKey"
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        print("applicationDidFinishLaunching")
    
        onMenuItem = NSMenuItem(title: "禁用", action: #selector(turnAction(_:)), keyEquivalent: "")
        exMenuItem = NSMenuItem(title: "退出", action: #selector(quitAction(_:)), keyEquivalent: "")
        startOnLaunchItem = NSMenuItem(title: "开机启动", action: #selector(startOnLaunch(_:)), keyEquivalent: "")

        statusMenu.items = [onMenuItem,startOnLaunchItem,exMenuItem]
        statusItem.menu = statusMenu
        //初始化状态
        setStatus(item: nil)
        //设置开启启动
        let startOnLaunch = UserDefaults.standard.bool(forKey: startOnLaunchKey)
        startOnLaunchItem.state = startOnLaunch ? .on : .off
        
    }
    
    @objc func quitAction(_ sender: NSMenuItem) {
        NSApplication.shared.terminate(self)
    }
    @objc func startOnLaunch(_ sender: NSMenuItem) {
        if sender.state == .on {
            sender.state = .off
        }else{
            sender.state = .on
        }
        UserDefaults.standard.set(sender.state == .on ? true : false, forKey: startOnLaunchKey)
        startAppWhenLogin(startup: sender.state == .on ? true : false)
    }
    
    @objc func turnAction(_ sender: NSMenuItem) {
        onLine = !onLine
        setStatus(item: sender)
    }
    func setStatus(item:NSMenuItem?) {
        item?.title = onLine ? "禁用" : "开启"
        statusItem.button?.image = NSImage(named: onLine ? "statusIcon" : "statusIcon1")
        if onLine {
            start()
        }else{
            stop()
        }
    }
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }
    lazy var httpServer:HTTPServer = {
        let httpServer = HTTPServer()
        httpServer.setType("_http._tcp.")
        httpServer.setPort(8123)
        httpServer.setConnectionClass(ZHttpConnection.self)
        let path = Bundle.main.resourcePath ?? ""
        httpServer.setDocumentRoot(path)
        return httpServer
    }()
    
    func start() {
        if httpServer.isRunning() {
            stop()
            print("httpServer:isRunning")
        }
        do {
            try httpServer.start()
        } catch let error{
            print("-----httpServerStartFail:\(error)")
        }
    }
    func stop() {
        httpServer.stop()
        print("-----httpServer:stop")
    }
    
    func startAppWhenLogin(startup:Bool) {
        let launcherAppIdentifier = "com.Marshal.HttpServer"
        // 开始注册/取消启动项
        SMLoginItemSetEnabled(launcherAppIdentifier as CFString, startup)
       
    }
}

class ZHttpConnection: HTTPConnection {
    override func supportsMethod(_ method: String!, atPath path: String!) -> Bool {
        if method.lowercased() == "post"{
            return true
        }
        return super.supportsMethod(method, atPath: path)
    }
    override func httpResponse(forMethod method: String!, uri path: String!) -> (NSObjectProtocol & HTTPResponse)! {
        if path.starts(with:"/getPasteboardString")  {
            print("-----:getPasteboardString")
            //读取剪切板
            if let content = NSPasteboard.general.string(forType: NSPasteboard.PasteboardType.string){
                return HTTPDataResponse.init(data: content.data(using: String.Encoding.utf8))
            }
        }else if path.starts(with: "/sendPasteboardString"){
            
        }
        return super.httpResponse(forMethod: method, uri: path)
    }
    override func processBodyData(_ postDataChunk: Data!) {
        
        DispatchQueue.main.async {
            // 将 NSData 转换为 String
            if let string = String(data: postDataChunk, encoding: .utf8) {
                NSPasteboard.general.declareTypes([NSPasteboard.PasteboardType.string], owner: nil)
                let res = NSPasteboard.general.setString(string, forType: NSPasteboard.PasteboardType.string)
                print(string) // 输出: 1234
            } else {
                print("Failed to convert data to string")
            }
                
        }
        
    }
}
