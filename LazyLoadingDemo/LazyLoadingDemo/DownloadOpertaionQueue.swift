//
//  DownloadOpertaionQueue.swift
//  LazyLoadingDemo
//
//  Created by Jinali Chavda on 17/05/24.
//

import Foundation

final class DownloadOpertaionQueue : OperationQueue {
    
    static let shared = DownloadOpertaionQueue()
    
    var imageCache = NSCache<AnyObject, AnyObject>()

    override init() {
        super.init()
        self.name = "download image queue"
    }
    
    func cancelOperation(urlStr:String) {
        for i in 0..<self.operations.count {
            if let operation = self.operations[i] as? DownloadTaskOperation {
                if operation.urlStr == urlStr{
                    operation.cancel()
                    break
                }
            }
        }
    }
    
}
