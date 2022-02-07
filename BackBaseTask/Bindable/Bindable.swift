//
//  Bindable.swift
//  BackBaseTask
//
//  Created by Mena Gamal on 07/02/2022.
//

import Foundation

public class MultipleBinding<T> {
    
    public typealias Listener = ((T) -> Void)
    
    private struct Binding {
        weak var object: AnyObject?
        let listener: Listener
    }
    
    private var bindings: [Binding] = []

    public var value: T {
        didSet {
            fire()
        }
    }

    public init(_ v: T) {
        value = v
    }

    public func bind(_ object: AnyObject? = nil, _ listener: @escaping Listener) {
        if let object = object {
            unbind(object)
        }
        bindings.append(Binding(object: object ?? self, listener: listener))
    }

    public func bindAndFire(_ object: AnyObject? = nil, _ listener: @escaping Listener) {
        bind(object, listener)
        listener(value)
    }

    public func unbind(_ object: AnyObject?) {
        if let object = object {
            bindings.removeAll { $0.object === object }
        }
    }

    private func fire() {
        removeDealocatedListeners()
        broadcastValue()
    }
    
    private func removeDealocatedListeners() {
        bindings.removeAll { $0.object == nil }
    }
    
    private func broadcastValue() {
        bindings.forEach { $0.listener(value) }
    }
}
