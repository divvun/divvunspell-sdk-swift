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

private func check_error() throws {
    if let divvunspell_err = divvunspell_err {
        let error = DivvunSpellError(message: String(cString: divvunspell_err))
        divvunspell_err_free()
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

public class ThfstChunkedBoxSpeller {
    private let handle: UnsafeRawPointer
    
    fileprivate init(handle: UnsafeRawPointer) {
        self.handle = handle
    }
    
    public func isCorrect(word: String) throws -> Bool {
        let result = word.withCString {
            divvun_thfst_chunked_box_speller_is_correct(
                self.handle, $0, divvunspell_err_callback)
        }
        
        try check_error()
        
        return result != 0
    }
    
    public func suggest(word: String) throws -> [String] {
        let suggestions = word.withCString {
            divvun_thfst_chunked_box_speller_suggest(handle, $0, divvunspell_err_callback)
        }
        
        try check_error()
        
        if suggestions.data == nil {
            return []
        }
        
        let length = divvun_vec_suggestion_len(suggestions, divvunspell_err_callback)
        try check_error()
        
        var out = [String]()
        
        for i in 0..<length {
            let ptr = divvun_vec_suggestion_get_value(suggestions, i, divvunspell_err_callback)
            try check_error()
            out.append(String(cString: ptr!))
            divvun_string_free(ptr!)
        }
        
        return out
    }
}

public class HfstZipSpeller {
    private let handle: UnsafeRawPointer
    
    fileprivate init(handle: UnsafeRawPointer) {
        self.handle = handle
    }
    
    public func isCorrect(word: String) throws -> Bool {
        let result = word.withCString {
            divvun_hfst_zip_speller_is_correct(
                self.handle, $0, divvunspell_err_callback)
        }
        
        try check_error()
        
        return result != 0
    }
    
    public func suggest(word: String) throws -> [String] {
        let suggestions = word.withCString {
            divvun_hfst_zip_speller_suggest(handle, $0, divvunspell_err_callback)
        }
        
        try check_error()
        
        if suggestions.data == nil {
            return []
        }
        
        let length = divvun_vec_suggestion_len(suggestions, divvunspell_err_callback)
        try check_error()
        
        var out = [String]()
        
        for i in 0..<length {
            let ptr = divvun_vec_suggestion_get_value(suggestions, i, divvunspell_err_callback)
            try check_error()
            out.append(String(cString: ptr!))
            divvun_string_free(ptr!)
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
        let handle = path.withCString {
            return divvun_thfst_chunked_box_speller_archive_open($0, divvunspell_err_callback)
        }
        
        try check_error()
        
        return ThfstChunkedBoxSpellerArchive(handle: handle!)
    }
    
    public func speller() throws -> ThfstChunkedBoxSpeller {
        let spellerHandle = divvun_thfst_chunked_box_speller_archive_speller(self.handle, divvunspell_err_callback)
        
        try check_error()
        
        return ThfstChunkedBoxSpeller(handle: spellerHandle!)
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
        let handle = path.withCString {
            return divvun_hfst_zip_speller_archive_open($0, divvunspell_err_callback)
        }
        try check_error()
        
        let ptr = divvun_hfst_zip_speller_archive_locale(handle!, divvunspell_err_callback)
        try check_error()
        let locale = String(cString: ptr!)
        divvun_string_free(ptr)
        
        return HfstZipSpellerArchive(handle: handle!, locale: locale)
    }
    
    public func speller() throws -> HfstZipSpeller {
        let spellerHandle = divvun_hfst_zip_speller_archive_speller(self.handle, divvunspell_err_callback)
        
        try check_error()
        
        return HfstZipSpeller(handle: spellerHandle!)
    }
}

public struct WordBoundIndices: IteratorProtocol, Sequence {
    public typealias Element = (UInt64, String)
    
    public mutating func next() -> (UInt64, String)? {
        var index: UInt64 = 0
        var cString = UnsafeMutablePointer<CChar>.allocate(capacity: 0)
        
        if divvun_word_bound_indices_next(handle, &index, &cString) == 0 {
            return nil
        }
        
        defer { divvun_string_free(cString) }
        let word = String(cString: cString)
        return (index, word)
    }
    
    private let string: [CChar]
    private let handle: UnsafeMutableRawPointer
    
    fileprivate init(_ string: String) {
        self.string = string.cString(using: .utf8)!
        self.handle = divvun_word_bound_indices(&self.string)
    }
}

public extension String {
    func wordBoundIndices() -> WordBoundIndices {
        return WordBoundIndices(self)
    }
}
