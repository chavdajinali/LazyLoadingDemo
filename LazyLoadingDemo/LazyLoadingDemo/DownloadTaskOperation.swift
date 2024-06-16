//
//  DownloadTaskOperation.swift
//  LazyLoadingDemo
//
//  Created by Jinali Chavda on 16/05/24.
//

import Foundation
import UIKit

class DownloadTaskOperation: Operation {
    private var task : URLSessionDataTask!
    
    //1.
    enum OperationState : Int {
        case isReady
        case isExecuting
        case isFinished
    }
    
    //2.
    private var state : OperationState = .isReady {
        willSet {
            self.willChangeValue(forKey: "isExecuting")
            self.willChangeValue(forKey: "isFinished")
        }
        
        didSet {
            self.didChangeValue(forKey: "isExecuting")
            self.didChangeValue(forKey: "isFinished")
        }
    }
    
    //3.
    override var isReady: Bool { return state == .isReady }
    override var isExecuting: Bool { return state == .isExecuting }
    override var isFinished: Bool { return state == .isFinished }
    var urlStr : String  = ""

    //4.
    init(url: String, completion: @escaping (UIImage?, Error?) -> ()) {
        
        super.init()
        urlStr = url
        guard let url = URL(string: url) else { return }
        
        // retrieves image if already available in cache
        if let imageFromCache = DownloadOpertaionQueue.shared.imageCache.object(forKey: url as AnyObject) as? UIImage {
            self.state = .isFinished
            completion(imageFromCache, nil)
        } else {
            task = URLSession.shared.dataTask(with: url, completionHandler: {  [weak self] (data, resp, err) in
                //6.
                print("begin download task")

                if (self?.isCancelled == true) {
                    print("Don't have to update UI")
                    self?.state = .isFinished
                    return
                }
                
                if let err = err {
                    completion(nil, err)
                    self?.state = .isFinished
                    return
                }
                // setup image cache if not already available in cache
                if let imageData = data {
                    if let unwrappedData = data, let imageToCache = UIImage(data: unwrappedData) {
                        DownloadOpertaionQueue.shared.imageCache.setObject(imageToCache, forKey: url as AnyObject)
                    }
                    self?.state = .isFinished
                    completion(UIImage(data: imageData), nil)
                } else {
                    completion(nil, NSError(domain: "download task operation", code: 0, userInfo: ["message": "invalid image data"]))
                }
                self?.state = .isFinished
            })
        }
    }
    
    //5.
    override func start() {
        if (self.isCancelled) {
            print("Task is cancelled before executed")
            state = .isFinished
            return
        }
        
        state = .isExecuting
        self.task.resume()
    }
    
    //7.
    override func cancel() {
        super.cancel()
        
        if (state == .isExecuting) {
            task.cancel()
        }
    }
       
}
