//
//  DivvunSpell.swift
//  DivvunSpell
//
//  Created by Brendan Molloy on 2019-10-08.
//

import Foundation

public struct DivvunSpellError: Error {
    public let message: String
}

public func divvunEnableLogging() {
    divvun_enable_logging()
}

private func assertNoError() throws {
    if let errMsg = err {
        let error = DivvunSpellError(message: errMsg)
        err = nil
        throw error
    }
}

public struct SliceIterator: IteratorProtocol {
    private let slice: rust_slice_t
    private var current: Int = 0
    
    public typealias Element = UInt8
    
    public mutating func next() -> UInt8? {
        if current >= self.slice.len {
            return nil
        }
        
        let v = self.slice.data!
            .assumingMemoryBound(to: UInt8.self)
            .advanced(by: current)
            .pointee
        
        self.current += 1
        
        return v
    }
    
    init(_ slice: rust_slice_t) {
        self.slice = slice
    }
}

extension rust_slice_t: Sequence {
    public typealias Element = UInt8
    public typealias Iterator = SliceIterator
    
    public var underestimatedCount: Int {
        return Int(self.len)
    }
    
    public func makeIterator() -> SliceIterator {
        return SliceIterator(self)
    }
}

extension rust_slice_t: Collection {
    public typealias Index = UInt
    
    public var startIndex: UInt { return 0 }
    public var endIndex: UInt { return self.len }
    
    public func index(after i: UInt) -> UInt {
        return i + 1
    }
    
    public subscript(position: UInt) -> UInt8 {
        return self.data!
            .assumingMemoryBound(to: UInt8.self)
            .advanced(by: Int(position))
            .pointee
    }
}

extension Sequence where Self.Element == String {
    @inlinable
    func withRustSlices<T>(callback: ([rust_slice_t]) -> T) -> T {
        let strings = self.map { $0.ensureContiguous() }
        let slices = strings.compactMap { $0.withRustSlice(callback: { $0 }) }
        return callback(slices)
    }
}

extension String {
    @inlinable
    func ensureContiguous() -> String {
        if self.isContiguousUTF8 {
            return self
        } else {
            var copied = self
            copied.makeContiguousUTF8()
            return copied
        }
    }
    
    @inlinable
    func withRustSlice<T>(callback: (rust_slice_t) -> T) -> T? {
        let value = self.ensureContiguous()
        
        return value.utf8.withContiguousStorageIfAvailable { pointer in
            let raw = UnsafeMutableRawPointer(mutating: pointer.baseAddress!)
            let slice = rust_slice_t(data: raw, len: rust_usize_t(pointer.count))
            return callback(slice)
        }
    }
}

extension rust_bool_t: ExpressibleByBooleanLiteral {
    public typealias BooleanLiteralType = Bool
    
    @inlinable
    public init(booleanLiteral value: Bool) {
        self.init()
        self.internal_value = value ? 1 : 0
    }
    
    @inlinable
    public var value: Bool {
        self.internal_value != 0
    }
}

fileprivate var err: String? = nil

fileprivate let errCallback: @convention(c) (UnsafeMutableRawPointer?, rust_usize_t) -> Void = {
    (ptr, len) in
    
    if let ptr = ptr {
        err = String(bytes: rust_slice_t(data: ptr, len: len), encoding: .utf8)
    }
}

public protocol Speller {
    func isCorrect(word: String) throws -> Bool
    func suggest(word: String) throws -> [String]
}

public class ThfstChunkedBoxSpeller: Speller {
    private let handle: UnsafeRawPointer
    
    fileprivate init(handle: UnsafeRawPointer) {
        self.handle = handle
    }
    
    public func isCorrect(word: String) throws -> Bool {
        let result = word.withRustSlice(callback: { slice in
            divvun_thfst_chunked_box_speller_is_correct(
                self.handle, slice, errCallback)
        })
        
        try assertNoError()
        return result!.value
    }
    
    public func suggest(word: String) throws -> [String] {
        let suggestions = word.withRustSlice(callback: { slice in
            divvun_thfst_chunked_box_speller_suggest(
                handle, slice, errCallback)
        })
        
        try assertNoError()
        
        if suggestions!.data == nil {
            return []
        }
        
        let length = divvun_vec_suggestion_len(suggestions!, errCallback)
        try assertNoError()
        
        var out = [String]()
        
        for i in 0..<length {
            let ptr = divvun_vec_suggestion_get_value(suggestions!, i, errCallback)
            try assertNoError()
            out.append(String(bytes: ptr, encoding: .utf8)!)
            cffi_string_free(ptr)
        }
        
        return out
    }
}

public class HfstZipSpeller: Speller {
    private let handle: UnsafeRawPointer

    fileprivate init(handle: UnsafeRawPointer) {
        self.handle = handle
    }
    
    public func isCorrect(word: String) throws -> Bool {
        let result = word.withRustSlice(callback: { slice in
            divvun_hfst_zip_speller_is_correct(
                self.handle, slice, errCallback)
        })
        
        try assertNoError()
        return result!.value
    }
    
    public func suggest(word: String) throws -> [String] {
        let suggestions = word.withRustSlice(callback: { slice in
            divvun_hfst_zip_speller_suggest(
                handle, slice, errCallback)
        })
        
        try assertNoError()
        
        if suggestions!.data == nil {
            return []
        }
        
        let length = divvun_vec_suggestion_len(suggestions!, errCallback)
        try assertNoError()
        
        var out = [String]()
        
        for i in 0..<length {
            let ptr = divvun_vec_suggestion_get_value(suggestions!, i, errCallback)
            try assertNoError()
            out.append(String(bytes: ptr, encoding: .utf8)!)
            cffi_string_free(ptr)
        }
        
        return out
    }
}

public class ThfstChunkedBoxSpellerArchive {
    private let handle: UnsafeRawPointer

    private init(handle: UnsafeRawPointer) {
        self.handle = handle
    }

    public static func open(path: String) throws -> ThfstChunkedBoxSpellerArchive {
        let handle = path.withRustSlice(callback: { slice in
            divvun_thfst_chunked_box_speller_archive_open(
                slice, errCallback)
        })
        try assertNoError()
        return ThfstChunkedBoxSpellerArchive(handle: handle!)
    }

    public func speller() throws -> ThfstChunkedBoxSpeller {
        let spellerHandle = divvun_thfst_chunked_box_speller_archive_speller(self.handle, errCallback)
        try assertNoError()
        return ThfstChunkedBoxSpeller(handle: spellerHandle)
    }
}

public class HfstZipSpellerArchive {
    private let handle: UnsafeRawPointer

    public let locale: String

    private init(handle: UnsafeRawPointer, locale: String) {
        self.handle = handle
        self.locale = locale
    }

    public static func open(path: String) throws -> HfstZipSpellerArchive {
        let handle = path.withRustSlice(callback: { slice in
            divvun_hfst_zip_speller_archive_open(slice, errCallback)
        })
        try assertNoError()

        let ptr = divvun_hfst_zip_speller_archive_locale(handle!, errCallback)
        try assertNoError()
        let locale = String(bytes: ptr, encoding: .utf8)!
        cffi_string_free(ptr)

        return HfstZipSpellerArchive(handle: handle!, locale: locale)
    }

    public func speller() throws -> HfstZipSpeller {
        let spellerHandle = divvun_hfst_zip_speller_archive_speller(self.handle, errCallback)
        try assertNoError()
        return HfstZipSpeller(handle: spellerHandle)
    }
}

public struct CursorContext {
    public let secondBefore: (UInt, String)?
    public let firstBefore: (UInt, String)?
    public let current: (UInt, String)
    public let currentOffset: Int
    public let firstAfter: (UInt, String)?
    public let secondAfter: (UInt, String)?
}

public extension CursorContext {
    static func from(leftPart: String, rightPart: String) throws -> CursorContext {
        let slice = leftPart.withRustSlice(callback: { leftPartSlice in
            rightPart.withRustSlice(callback: { rightPartSlice in
                divvun_cursor_context(leftPartSlice, rightPartSlice, errCallback)
            })
        })
        
        try assertNoError()
        defer {
             cffi_vec_free(slice!!)
        }
        
        let buf = ByteBuffer(bytes: Array(slice!!))
        let wc = WordContext.getRootAsWordContext(bb: buf)
        let offset = getCurrentOffsetFrom(leftPart: leftPart, rightPart: rightPart)
        
        guard let current = wc.current else {
            return CursorContext(secondBefore: nil,
                                 firstBefore: nil,
                                 current: (0, ""),
                                 currentOffset: offset,
                                 firstAfter: nil,
                                 secondAfter: nil)
        }
        
        return CursorContext(secondBefore: wc.secondBefore?.asTuple(),
                             firstBefore: wc.firstBefore?.asTuple(),
                             current: current.asTuple(),
                             currentOffset: offset,
                             firstAfter: wc.firstAfter?.asTuple(),
                             secondAfter: wc.secondAfter?.asTuple())
    }

    static func getCurrentOffsetFrom(leftPart: String, rightPart: String) -> Int {
        var leftCurrentChunk: String.SubSequence?
        var rightCurrentChunk: String.SubSequence?

        var currentWord: String

        // Build current word
        let currentLeftIndex = leftPart.lastIndex(where: { $0 == " " || $0 == "\n" })
        if let currentLeftIndex = currentLeftIndex {
            leftCurrentChunk = leftPart.suffix(after: currentLeftIndex)
        } else {
            leftCurrentChunk = leftPart.suffix(from: leftPart.startIndex)
        }

        let currentRightIndex = rightPart.firstIndex(where: { $0 == " " || $0 == "\n" }) ?? rightPart.endIndex
        rightCurrentChunk = rightPart.prefix(upTo: currentRightIndex)

        var offset: Int = 0
        if let left = leftCurrentChunk, let right = rightCurrentChunk {
            currentWord = "\(left)\(right)"
            offset = left.count
        } else if let left = leftCurrentChunk {
            currentWord = String(left)
            offset = currentWord.count
        } else if let right = rightCurrentChunk {
            currentWord = String(right)
        } else {
            currentWord = ""
        }

        return offset
    }
}

fileprivate extension IndexedWord {
    func asTuple() -> (UInt, String) {
        return (UInt(self.index), self.value ?? "")
    }
}

extension String {
    func suffix(after index: String.Index) -> String.SubSequence {
        if index >= endIndex {
            return suffix(from: endIndex)
        }

        return suffix(from: self.index(after: index))
    }
}

public class WordIndices: IteratorProtocol, Sequence {
    public typealias Element = (UInt64, String)

    private let string: [CChar]
    private let handle: UnsafeMutableRawPointer

    fileprivate init(_ string: String) {
        self.string = string.cString(using: .utf8)!
        self.handle = divvun_word_indices(&self.string)
    }

    public func next() -> (UInt64, String)? {
        var index: UInt64 = 0
        var cString = UnsafeMutablePointer<CChar>.allocate(capacity: 0)

        if !divvun_word_indices_next(handle, &index, &cString).value {
            return nil
        }

        defer { divvun_cstr_free(cString) }
        let word = String(cString: cString)
        return (index, word)
    }

    deinit {
        divvun_word_indices_free(self.handle)
    }
}

public extension String {
    func wordIndices() -> WordIndices {
        return WordIndices(self)
    }
}

//public struct WordBoundIndices: IteratorProtocol, Sequence {
//    public typealias Element = (UInt64, String)
//
//    public mutating func next() -> (UInt64, String)? {
//        var index: UInt64 = 0
//        var cString = UnsafeMutablePointer<CChar>.allocate(capacity: 0)
//
//        if divvun_word_bound_indices_next(handle, &index, &cString) == 0 {
//            return nil
//        }
//
//        defer { cffi_string_free(cString) }
//        let word = String(cString: cString)
//        return (index, word)
//    }
//
//    private let string: [CChar]
//    private let handle: UnsafeMutableRawPointer
//
//    fileprivate init(_ string: String) {
//        self.string = string.cString(using: .utf8)!
//        self.handle = divvun_word_bound_indices(&self.string)
//    }
//}
//
//public extension String {
//    func wordBoundIndices() -> WordBoundIndices {
//        return WordBoundIndices(self)
//    }
//}

