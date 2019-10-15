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
