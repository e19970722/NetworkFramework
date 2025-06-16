//
//  CustomHeader.swift
//  20250428_NetworkFramework
//
//  Created by Yen Lin on 2025/6/16.
//

import Foundation

struct customHeader {
    let Headspec: [UInt8]
    let serialNo: Int32
    let dataLength: Int32
    let orderNo: Int32
    
    func toData() -> Data {
        var data = Data()
        
        // Headspec: [UInt8] 要是長度 4
        var header = Headspec
        if header.count < 4 {
            header += Array(repeating: 0, count: 4 - header.count)
        }
        data.append(contentsOf: header.prefix(4))
        withUnsafeBytes(of: serialNo.bigEndian) { data.append(contentsOf: $0) }
        withUnsafeBytes(of: dataLength.bigEndian) { data.append(contentsOf: $0) }
        withUnsafeBytes(of: orderNo.bigEndian) { data.append(contentsOf: $0) }
        return data
    }
}
