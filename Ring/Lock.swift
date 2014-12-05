//
//  Lock.swift
//  Ring
//
//  Created by Jeremy Tregunna on 2014-12-04.
//  Copyright (c) 2014 Jeremy Tregunna. All rights reserved.
//

import Foundation

internal protocol ReadWriteLock {
    mutating func withReadLock<T>(block: () -> T) -> T
    mutating func withWriteLock<T>(block: () -> T) -> T
}

internal class Lock<T>: ReadWriteLock {
    let lock: NSLocking
    
    init() {
        self.lock = NSLock()
    }
    
    func withReadLock<T>(block: () -> T) -> T {
        self.lock.lock()
        var result: T = block()
        self.lock.unlock()
        return result
    }
    
    func withWriteLock<T>(block: () -> T) -> T {
        self.lock.lock()
        var result: T = block()
        self.lock.unlock()
        return result
    }
}
