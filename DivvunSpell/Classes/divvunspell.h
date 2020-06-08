#ifdef __cplusplus
extern "C" {
#endif

#include <stdlib.h>
#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <stdbool.h>

#pragma once

#ifndef __APPLE__
#define _Nonnull
#define _Nullable
#endif

// Rust FFI required types
typedef struct rust_bool_s {
    uint8_t internal_value;
} rust_bool_t;

typedef uintptr_t rust_usize_t;

typedef struct rust_slice_s {
    void *_Nullable data;
    rust_usize_t len;
} rust_slice_t;

#define ERR_CALLBACK void (*_Nonnull exception)(void *_Nullable, rust_usize_t)

struct CaseHandlingConfig {
    float start_penalty;
    float end_penalty;
    float mid_penalty;
};

struct SpellerConfig {
    rust_usize_t n_best;
    float max_weight;
    float beam;
    struct CaseHandlingConfig case_handling;
    rust_usize_t node_pool_size;
};

extern const void *_Nonnull
divvun_thfst_chunked_box_speller_archive_open(rust_slice_t path, ERR_CALLBACK);

extern const void *_Nonnull
divvun_thfst_chunked_box_speller_archive_speller(const void *_Nonnull handle, ERR_CALLBACK);

extern rust_bool_t
divvun_thfst_chunked_box_speller_is_correct(const void *_Nonnull speller,
                                            rust_slice_t word,
                                            ERR_CALLBACK);

extern const rust_slice_t
divvun_thfst_chunked_box_speller_suggest(const void *_Nonnull speller,
                                         rust_slice_t word,
                                         ERR_CALLBACK);

extern rust_slice_t
divvun_thfst_chunked_box_speller_suggest_with_config(
    const void *_Nonnull speller,
    rust_slice_t word,
    struct SpellerConfig *_Nonnull config,
    ERR_CALLBACK);

extern const void *_Nonnull
divvun_thfst_box_speller_archive_open(rust_slice_t path, ERR_CALLBACK);

extern rust_slice_t
divvun_thfst_box_speller_archive_speller(const void *_Nonnull handle, ERR_CALLBACK);

extern rust_bool_t
divvun_thfst_box_speller_is_correct(const void *_Nonnull speller,
                                    rust_slice_t word,
                                    ERR_CALLBACK);

extern const rust_slice_t
divvun_thfst_box_speller_suggest(const void *_Nonnull speller,
                                 rust_slice_t word,
                                 ERR_CALLBACK);

extern rust_slice_t
divvun_thfst_box_speller_suggest_with_config(
    const void *_Nonnull speller,
    rust_slice_t word,
    struct SpellerConfig *_Nonnull config,
    ERR_CALLBACK);

extern const void *_Nonnull
divvun_hfst_zip_speller_archive_open(rust_slice_t path, ERR_CALLBACK);

extern const void *_Nonnull
divvun_hfst_zip_speller_archive_speller(const void *_Nonnull handle, ERR_CALLBACK);

extern rust_slice_t
divvun_hfst_zip_speller_archive_locale(const void *_Nonnull handle, ERR_CALLBACK);

extern rust_bool_t
divvun_hfst_zip_speller_is_correct(const void *_Nonnull speller, 
                                   rust_slice_t word,
                                   ERR_CALLBACK);

extern rust_slice_t
divvun_hfst_zip_speller_suggest(const void *_Nonnull speller,
                                rust_slice_t word,
                                ERR_CALLBACK);

extern rust_slice_t
divvun_hfst_zip_speller_suggest_with_config(
    const void *_Nonnull speller,
    rust_slice_t word,
    struct SpellerConfig *_Nonnull config,
    ERR_CALLBACK);

extern rust_usize_t
divvun_vec_suggestion_len(const rust_slice_t suggestions, ERR_CALLBACK);

extern rust_slice_t
divvun_vec_suggestion_get_value(
    const rust_slice_t suggestions,
    rust_usize_t index,
    ERR_CALLBACK);

extern void
cursed_string_free(rust_slice_t value);

extern void
cursed_vec_free(rust_slice_t value);

extern void
divvun_fbs_free(rust_slice_t value);

extern rust_slice_t
divvun_cursor_context(rust_slice_t left, rust_slice_t right, ERR_CALLBACK);

extern void
divvun_enable_logging();

//extern void *_Nonnull
//divvun_word_bound_indices(rust_slice_t utf8_string);
//
//extern rust_bool_t
//divvun_word_bound_indices_next(const void *_Nonnull handle,
//                               uint64_t *_Nonnull out_index,
//                               char *_Nonnull *_Nonnull out_string);
//
//extern void
//word_bound_indices_free(void *_Nonnull handle);

#ifdef __cplusplus
}
#endif
