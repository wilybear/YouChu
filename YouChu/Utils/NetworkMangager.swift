//
//  NetworkMangager.swift
//  YouChu
//
//  Created by 김현식 on 2021/06/04.
//
import Foundation
import Network

class NetMonitor {
    static public let shared = NetMonitor()
    private var monitor: NWPathMonitor
    private var queue = DispatchQueue.global()
    var netOn: Bool = true
    var connType: ConnectionType = .wifi
    var internetConnection: Bool = true

    private init() {
        self.monitor = NWPathMonitor()
        self.queue = DispatchQueue.global(qos: .background)
        self.monitor.start(queue: queue)
    }

    func startMonitoring() {
        self.monitor.pathUpdateHandler = { path in
            self.netOn = path.status == .satisfied
            self.connType = self.checkConnectionTypeForPath(path)
            self.internetConnection = path.status == .satisfied
            print("running")
        }
    }

    func stopMonitoring() {
        self.monitor.cancel()
    }

    func checkConnectionTypeForPath(_ path: NWPath) -> ConnectionType {
        if path.usesInterfaceType(.wifi) {
            return .wifi
        } else if path.usesInterfaceType(.wiredEthernet) {
            return .ethernet
        } else if path.usesInterfaceType(.cellular) {
            return .cellular
        }
        return .unknown
    }
}

public enum ConnectionType {
    case wifi
    case ethernet
    case cellular
    case unknown
}
