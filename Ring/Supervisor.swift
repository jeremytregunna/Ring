//
//  Supervisor.swift
//  Ring
//
//  Created by Jeremy Tregunna on 2014-12-04.
//  Copyright (c) 2014 Jeremy Tregunna. All rights reserved.
//

import Foundation

internal class Supervisor<T> {
    private var lock: ReadWriteLock
    private var item: T

    init(_ item: T) {
        self.lock = Lock<T>()
        self.item = item
    }

    func withReadLock<U>(block: (T) -> U) -> U {
        return lock.withReadLock { [unowned self] in
            return block(self.item)
        }
    }

    func withWriteLock<U>(block: (inout T) -> U) -> U {
        return lock.withWriteLock { [unowned self] in
            return block(&self.item)
        }
    }
}
