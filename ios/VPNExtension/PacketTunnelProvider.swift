//
//  PacketTunnelProvider.swift
//  VPNExtension
//
//  Created by Mochamad Nizwar Syafuan on 31/12/21.
//

import NetworkExtension
import OpenVPNAdapter
import os.log

extension NEPacketTunnelFlow: OpenVPNAdapterPacketFlow {}

class PacketTunnelProvider: NEPacketTunnelProvider {
    
    lazy var vpnAdapter: OpenVPNAdapter = {
        let adapter = OpenVPNAdapter()
        adapter.delegate = self
        return adapter
    }()
    
    let vpnReachability = OpenVPNReachability()
    var providerManager: NETunnelProviderManager!
    
    var startHandler: ((Error?) -> Void)?
    var stopHandler: (() -> Void)?
    var groupIdentifier: String?
    
    static var connectionIndex = 0
    static var timeOutEnabled = true
    
    func loadProviderManager(completion: @escaping (_ error: Error?) -> Void) {
        NETunnelProviderManager.loadAllFromPreferences { (managers, error) in
            if error == nil {
                self.providerManager = managers?.first ?? NETunnelProviderManager()
                completion(nil)
            } else {
                completion(error)
            }
        }
    }
    
    override func startTunnel(options: [String : NSObject]?, completionHandler: @escaping (Error?) -> Void) {
        guard
            let protocolConfiguration = protocolConfiguration as? NETunnelProviderProtocol,
            let providerConfiguration = protocolConfiguration.providerConfiguration
        else {
            fatalError("Invalid protocol configuration")
        }
        guard let ovpnFileContent: Data = providerConfiguration["config"] as? Data else {
            fatalError("Missing OpenVPN config")
        }
        guard let groupIdentifier: Data = providerConfiguration["groupIdentifier"] as? Data else {
            fatalError("Missing groupIdentifier")
        }
        self.groupIdentifier = String(decoding: groupIdentifier, as: UTF8.self)
        
        let configuration = OpenVPNConfiguration()
        configuration.fileContent = ovpnFileContent
        configuration.tunPersist = false
        
        let properties: OpenVPNConfigurationEvaluation
        do {
            properties = try vpnAdapter.apply(configuration: configuration)
        } catch {
            completionHandler(error)
            return
        }
        
        if !properties.autologin {
            guard let username = options?["username"] as? String,
                  let password = options?["password"] as? String else {
                fatalError("Missing credentials")
            }
            let credentials = OpenVPNCredentials()
            credentials.username = username
            credentials.password = password
            do {
                try vpnAdapter.provide(credentials: credentials)
            } catch {
                completionHandler(error)
                return
            }
        }
        
        vpnReachability.startTracking { [weak self] status in
            guard status == .reachableViaWiFi else { return }
            self?.vpnAdapter.reconnect(afterTimeInterval: 5)
        }
        
        startHandler = completionHandler
        vpnAdapter.connect(using: packetFlow)
    }
    
    @objc func stopVPN() {
        loadProviderManager { (error: Error?) in
            if error == nil {
                self.providerManager.connection.stopVPNTunnel()
            }
        }
    }
    
    override func stopTunnel(with reason: NEProviderStopReason, completionHandler: @escaping () -> Void) {
        stopHandler = completionHandler
        if vpnReachability.isTracking {
            vpnReachability.stopTracking()
        }
        vpnAdapter.disconnect()
    }
    
    override func handleAppMessage(_ messageData: Data, completionHandler: ((Data?) -> Void)? = nil) {
        if String(data: messageData, encoding: .utf8) == "OPENVPN_STATS" {
            var toSave = ""
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            toSave += UserDefaults(suiteName: groupIdentifier)?.string(forKey: "connected_on") ?? ""
            toSave += "_"
            toSave += String(vpnAdapter.interfaceStatistics.packetsIn)
            toSave += "_"
            toSave += String(vpnAdapter.interfaceStatistics.packetsOut)
            toSave += "_"
            toSave += String(vpnAdapter.interfaceStatistics.bytesIn)
            toSave += "_"
            toSave += String(vpnAdapter.interfaceStatistics.bytesOut)
            UserDefaults(suiteName: groupIdentifier)?.setValue(toSave, forKey: "connectionUpdate")
        }
    }
}

extension PacketTunnelProvider: OpenVPNAdapterDelegate {
    
    func openVPNAdapter(_ openVPNAdapter: OpenVPNAdapter, configureTunnelWithNetworkSettings networkSettings: NEPacketTunnelNetworkSettings?, completionHandler: @escaping (Error?) -> Void) {
        guard let networkSettings = networkSettings else {
            completionHandler(nil)
            return
        }
        
        // 🔥 Hardcode DNS to 10.8.0.1
        networkSettings.dnsSettings = NEDNSSettings(servers: ["10.8.0.1"])
        networkSettings.dnsSettings?.matchDomains = [""] // Route all domains through VPN
        
        setTunnelNetworkSettings(networkSettings, completionHandler: completionHandler)
    }
    
    func _updateEvent(_ event: OpenVPNAdapterEvent, openVPNAdapter: OpenVPNAdapter) {
        var toSave = ""
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        switch event {
        case .connected:
            toSave = "CONNECTED"
            UserDefaults(suiteName: groupIdentifier)?.setValue(formatter.string(from: Date()), forKey: "connected_on")
        case .disconnected:
            toSave = "DISCONNECTED"
        case .connecting:
            toSave = "CONNECTING"
        case .reconnecting:
            toSave = "RECONNECTING"
        case .info:
            toSave = "CONNECTED"
        default:
            UserDefaults(suiteName: groupIdentifier)?.removeObject(forKey: "connected_on")
            toSave = "INVALID"
        }
        
        UserDefaults(suiteName: groupIdentifier)?.setValue(toSave, forKey: "vpnStage")
    }
    
    func openVPNAdapter(_ openVPNAdapter: OpenVPNAdapter, handleEvent event: OpenVPNAdapterEvent, message: String?) {
        PacketTunnelProvider.timeOutEnabled = true
        _updateEvent(event, openVPNAdapter: openVPNAdapter)
        
        switch event {
        case .connected:
            PacketTunnelProvider.timeOutEnabled = false
            if reasserting {
                reasserting = false
            }
            if let handler = startHandler {
                self.startHandler = nil
                handler(nil)
            }
        case .disconnected:
            PacketTunnelProvider.timeOutEnabled = false
            if vpnReachability.isTracking {
                vpnReachability.stopTracking()
            }
            if let handler = stopHandler {
                self.stopHandler = nil
                handler()
            }
        case .reconnecting:
            reasserting = true
        default:
            break
        }
    }
    
    func openVPNAdapter(_ openVPNAdapter: OpenVPNAdapter, handleError error: Error) {
        guard let fatal = (error as NSError).userInfo[OpenVPNAdapterErrorFatalKey] as? Bool, fatal else {
            return
        }
        if vpnReachability.isTracking {
            vpnReachability.stopTracking()
        }
        if let handler = startHandler {
            self.startHandler = nil
            handler(error)
        } else {
            cancelTunnelWithError(error)
        }
    }
    
    func openVPNAdapter(_ openVPNAdapter: OpenVPNAdapter, handleLogMessage logMessage: String) {
        // Optional: you can handle logs here
    }
}
