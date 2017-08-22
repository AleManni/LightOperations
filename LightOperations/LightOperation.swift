//
//  GAOperation.swift
//  GeoApp
//
//  Created by Alessandro Manni on 06/08/2017.
//  Copyright © 2017 Alessandro Manni. All rights reserved.
//

import Foundation

public enum OperationState: String {
    case ready, executing, finished, cancelled

    var keyPath: String {
        return "is" + (self.rawValue).capitalized
    }
}

public enum OperationError: Error {
    case networkError(Error)
    case unexpectedInputType(Any)
    case genericError(Error)
}

public enum OperationFinalResult<T> {
    case success(T)
    case error(OperationError)
}

open class LightOperation : Operation {

        open var operationFinalResult: OperationFinalResult<Any>?
        open var initialData: Any?
    var operationCompletion: ((OperationFinalResult<Any>) -> Void)

        override open var isAsynchronous: Bool {
            return true
        }

        var state = OperationState.ready {
            willSet {
                willChangeValue(forKey: state.keyPath)
                willChangeValue(forKey: newValue.keyPath)
            }
            didSet {
                didChangeValue(forKey: state.keyPath)
                didChangeValue(forKey: oldValue.keyPath)
            }
        }

        override open var isExecuting: Bool {
            return state == .executing
        }

        override open var isFinished: Bool {
            return state == .finished
        }

        override open var isCancelled: Bool {
            return state == .cancelled
        }

        init(operationCompletion: @escaping ((OperationFinalResult<Any>) -> Void)) {
            self.operationCompletion = operationCompletion
            super.init()
            self.name = String(describing: self)
        }

        override open func start() {
            addObserver(self, forKeyPath: OperationState.executing.keyPath, options: .new, context: nil)
            addObserver(self, forKeyPath: OperationState.finished.keyPath, options: .new, context: nil)
            addObserver(self, forKeyPath: OperationState.cancelled.keyPath, options: .new, context: nil)
            if self.isCancelled {
                state = .finished
            } else {
                state = .ready
                main()
            }
        }

        override open func main() {
            if self.isCancelled {
                state = .finished
                return
            } else {
                state = .executing
            }
        }

        override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
            guard let keyPath = keyPath else {
                return
            }
            switch keyPath {
            case OperationState.executing.keyPath:
                print("\(self.name ?? "un-named operation") is executing")
            case OperationState.finished.keyPath:
                print("\(self.name ?? "un-named operation") finished with result: \(String(describing: self.operationFinalResult))")
            case OperationState.cancelled.keyPath:
                print("\(self.name ?? "un-named operation") CANCELLED with result: \(String(describing: self.operationFinalResult))")
            default:
                return
            }
        }
        
        deinit {
            removeObserver(self, forKeyPath: OperationState.executing.keyPath)
            removeObserver(self, forKeyPath: OperationState.finished.keyPath)
            removeObserver(self, forKeyPath: OperationState.cancelled.keyPath)
        }
}
