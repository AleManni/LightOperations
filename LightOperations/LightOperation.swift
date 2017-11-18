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
    case inputDataMissing
    case genericError(Error)
}

public enum OperationFinalResult<T> {
    case success(T)
    case failure(OperationError)
}

/**
 This class is a basic subclass of Operation, providing its sublcasses with:
 - KVOs for all operation states
 - An initialData and operationFinalResult properties that are used by the Coupler class, but can also be set/read manually
 - An initializer, allowing to set an optional completionBlock for the operation
 Subclasses will need to override, at minimum, the main() function
 */
open class LightOperation : Operation {

    public var operationFinalResult: OperationFinalResult<Any>?
    public var initialData: Any?
    public var operationCompletion: ((OperationFinalResult<Any>) -> Void)

    override open var isAsynchronous: Bool {
        return true
    }

    public var state = OperationState.ready {
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
/**
     This initializer provides the opportunity to pass a completion block handling a OperationFinalResult type. The block can be executed at any point, e.g. at the end of the main() block of at any entry point provided by the state observer.
 */
    public init(operationCompletion: @escaping ((OperationFinalResult<Any>) -> Void) = { _ in }) {
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
/**
     By default, this function prints the name of the operation and its state to the consolle. 
     Sublcasses are encouraged to override it if needed.
 */
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
