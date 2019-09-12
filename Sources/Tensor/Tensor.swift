//
//  Tensor.swift
//  Tensor
//
//  Created by Michael Lockyer on 9/11/19.
//

import Foundation

/*
We use the BaseInteger protocol to define "Int" as a generic
constraint for SubscriptIndex. Without this, we would be limited
to the built in integer protocols, which include multiple
int types. If that were the case, we would have to check
for each int type individually inside our subscript method.
*/
protocol BaseInteger {}
extension Int: BaseInteger {}

/*
The SubscriptIndex protocol constrains the variadic parameters
passed to our subscript method to Int, and all range types.
*/
protocol SubscriptIndex {}
extension Int: SubscriptIndex {}
extension PartialRangeFrom: SubscriptIndex where Bound: BaseInteger {}
extension PartialRangeUpTo: SubscriptIndex where Bound: BaseInteger {}
extension PartialRangeThrough: SubscriptIndex where Bound: BaseInteger {}
extension ClosedRange: SubscriptIndex where Bound: BaseInteger {}
extension Range: SubscriptIndex where Bound: BaseInteger {}


fileprivate func computeStrides(forSizes sizes: Array<Int>) -> Array<Int> {
	var strides: Array<Int> = []
	for i in 1..<sizes.count {
		strides.append(sizes[i...].reduce(1, *))
	}
	strides.append(1)
	return strides
}

class Tensor<DTYPE: Numeric & Comparable>: CustomStringConvertible {
	var description: String {
		return ""
	}
	
	let storage: UnsafeMutablePointer<DTYPE>
	let count: Int
	
	let sizes: Array<Int>
	let strides: Array<Int>
	let offsets: Array<Int> = []
	
	init(_ sizes: Int...) {
		self.sizes = sizes
		self.strides = computeStrides(forSizes: sizes)
		self.count = sizes.reduce(1, *)
		self.storage = UnsafeMutablePointer<DTYPE>.allocate(capacity: self.count)
		for i in 0..<self.count {
			self.storage[i] = i as! DTYPE
		}
	}
	
	internal init(sizes: Array<Int>, strides: Array<Int>, storage: UnsafeMutablePointer<DTYPE>) {
		self.sizes = sizes
		self.strides = strides
		self.count = sizes.reduce(1, *)
		self.storage = storage
	}
	
	subscript(_ indices: SubscriptIndex...) -> Int {
		for subscriptIndex in indices {
			if let subscriptIndex = subscriptIndex as? PartialRangeFrom<Int> {
				print(subscriptIndex)
			} else if let subscriptIndex = subscriptIndex as? PartialRangeUpTo<Int> {
				print(subscriptIndex)
			} else if let subscriptIndex = subscriptIndex as? PartialRangeThrough<Int> {
				print(subscriptIndex)
			} else if let subscriptIndex = subscriptIndex as? ClosedRange<Int> {
				print(subscriptIndex)
			} else if let subscriptIndex = subscriptIndex as? Range<Int> {
				print(subscriptIndex)
			} else {
				let subscriptIndex = subscriptIndex as! Int
				print(subscriptIndex)
			}
			
			
		}
		return 0
	}
	
	subscript(_ indices: Int...) -> DTYPE {
		var offset: Int = 0
		for (i, index) in indices.enumerated() {
			offset += index * self.strides[i]
		}
		return self.storage[offset]
	}
	
	func arrayValue() {
		
	}
	
	deinit {
		self.storage.deallocate()
	}
}
