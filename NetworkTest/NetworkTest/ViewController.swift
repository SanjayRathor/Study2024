//
//  ViewController.swift
//  NetworkTest
//
//  Created by Sanjay Rathor on 14/02/25.
//

import UIKit
import CoreTelephony
import NetworkExtension

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("NetworkType- \(getNetworkType())")
        print("getWiFiSignalStrength- \(getWiFiSignalStrength())")
        
    }
    
    
    func getNetworkType() -> String {
        let networkInfo = CTTelephonyNetworkInfo()
        
        if let currentRadioTech = networkInfo.serviceCurrentRadioAccessTechnology?.values.first {
            switch currentRadioTech {
            case CTRadioAccessTechnologyGPRS, CTRadioAccessTechnologyEdge:
                return "2G"
            case CTRadioAccessTechnologyWCDMA, CTRadioAccessTechnologyHSDPA,
                CTRadioAccessTechnologyHSUPA, CTRadioAccessTechnologyCDMA1x,
                CTRadioAccessTechnologyCDMAEVDORev0, CTRadioAccessTechnologyCDMAEVDORevA,
            CTRadioAccessTechnologyCDMAEVDORevB:
                return "3G"
            case CTRadioAccessTechnologyLTE:
                return "4G"
            case CTRadioAccessTechnologyNRNSA, CTRadioAccessTechnologyNR:
                return "5G"
            default:
                return "Unknown"
            }
        }
        
        return "No Cellular Connection"
    }
    
    
   

    func getWiFiSignalStrength() {
      /*  NEHotspotHelper.register(options: nil, queue: DispatchQueue.main) { (cmd) in
            if let networkList = cmd.networkList {
                for network in networkList {
                    print("SSID: \(network.ssid), RSSI: \(network.signalStrength)")
                }
            }
        }*/
        if let carrierInfo = CTTelephonyNetworkInfo().serviceCurrentRadioAccessTechnology {
            let provider = CTTelephonyNetworkInfo().serviceSubscriberCellularProviders
            if let carrier = provider?.values.first {
                let mnc = carrier.mobileNetworkCode
                print("MNC: \(mnc ?? "Unknown")")
            }
        }

    }

    
}
