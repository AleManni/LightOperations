//
//  OperationsCoupler.swift
//  GeoApp
//
//  Created by Alessandro Manni on 06/08/2017.
//  Copyright © 2017 Alessandro Manni. All rights reserved.
//

import Foundation

/**
Transforming function
- seealso: `public init(finishedOperation: LightOperation, startingOperation: LightOperation, transformer: OperationTransformer?`, for a description of the errors that can be thrown
*/
public typealias OperationTransformer = (Any) -> Any?

/**
This class provides an interface between two instances of LightOperations, allowing to pass the finalResult of the finishedOperaton into the initialData of the startingOperation.
 This same class will also automatically take care of setting the correct dependencies between the finished operation and the starting operation.
 A transformation block can be injected through initialization, in order to transform the oputut of the finishedOperation before passing it to the input of the startingOperation.
*/
public class CouplerOperation: Operation {
    private var finishedOperation: LightOperation
    private var startingOperation: LightOperation
    private var operationTransformer: OperationTransformer

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
/**
     Initialize the coupler operation
     - Parameter finishedOperation: the input operation. This operation must be a sublcass of LightOperation
     - Parameter startingOperation: the output operation. This operation must be a sublcass of LightOperation
     - Parameter transformer:  an optional transformer block. If this parameter is `nil`, the output of the finished operation will be passed directly to the input of the startingOperation
 */
    public init(finishedOperation: LightOperation, startingOperation: LightOperation, transformer: OperationTransformer? = { input in
        return input}) {
        self.finishedOperation = finishedOperation
        self.startingOperation = startingOperation
        self.operationTransformer = transformer!
        super.init()
        self.name = String(describing: self)
        self.addDependency(finishedOperation)
        startingOperation.addDependency(self)
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
        guard let result = self.finishedOperation.operationFinalResult else {
            state = .cancelled
            self.cancel()
            return
        }
        switch result {
        case .success(let data):
            if let inputData = self.operationTransformer(data) {
                self.startingOperation.initialData = inputData
                self.state = .finished
            }
        default:
            state = .cancelled
            self.cancel()
            return
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
            print("\(self.name ?? "un-named operation") finished")
        case OperationState.cancelled.keyPath:
            print("\(self.name ?? "un-named operation") CANCELLED")
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
