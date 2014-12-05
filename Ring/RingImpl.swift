//
//  Ring.swift
//  Ring
//
//  Created by Jeremy Tregunna on 2014-12-04.
//  Copyright (c) 2014 Jeremy Tregunna. All rights reserved.
//

import Foundation

private struct UnsafeStorage<T> {
    var storage: [T?]
    let maxCount: Int
    var readPosition: Int  = 0
    var writePosition: Int = 0
    var itemCount: Int     = 0
    
    init(storage: [T?], maxCount: Int) {
        self.storage  = storage
        self.maxCount = maxCount
    }
}

public class Ring<T>: NSObject {
    private let supervisor: Supervisor<UnsafeStorage<T>>
    
    public init(count: Int) {
        let storage     = UnsafeStorage(storage: [T?](count: count, repeatedValue: Optional.None), maxCount: count)
        self.supervisor = Supervisor(storage)
    }

    public func write(value: T?) -> () {
        return self.supervisor.withWriteLock { storage in
            var nextPosition  = storage.writePosition + 1
            if nextPosition  >= storage.maxCount {
                nextPosition  = 0
            }

            storage.storage[nextPosition]  = value
            storage.itemCount             += 1
            storage.writePosition          = nextPosition

            return ()
        }
    }

    public func read() -> T? {
        return self.supervisor.withWriteLock { storage in
            var nextPosition  = storage.readPosition + 1
            if nextPosition > storage.writePosition {
                nextPosition  = storage.writePosition
            } else if nextPosition  >= storage.maxCount {
                nextPosition  = 0
            }

            let value = storage.storage[nextPosition]
            storage.readPosition = nextPosition

            return value
        }
    }
}
