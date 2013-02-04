#include <err.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <unistd.h>
#include "aes.h"


/*
 * Error messages
 */
const char  no_aes_ni_error_msg[] = "Your processor does not support aes-ni";

const char  usage_msg[] =
    "usage: aes <command> key_file\n\n"
    "Crypt/Decrypt data with AES using aes-ni instructions and PKCS#7 padding.\n\n"
    "commands:\n"
    "\tc\tcrypt\n"
    "\td\tdecrypt\n\n"
    "key_file is a file containing a raw 128/192/256 bits key.\n\n"
    "example: aes c my_key_filename < text > cypher\n";

const char  key_size_error_msg[] = "Unsupported key size";

const char  tty_input_error_msg[] = "No interactive mode, please stream content in";

const char  bad_block_length_error_msg[] = "cypher length is not a multiple of 16 bytes";


/*
 * Types
 */

/* Stream operation driver */
typedef void        (*stream_dispatch)();

/* Couple of AES routines */
typedef struct {
    void            (*set_round_keys)(aes_key *);
    void            (*process_block)(aes_block *);
} block_dispatch;

/* Application operational settings */
typedef struct {
    stream_dispatch op;
    block_dispatch  *block_op;
    aes_key         key;
} config;


/*
 * Data
 */

/* Encryption/Decryption dispatch tables */
static block_dispatch   stream_encrypt_dispatch[] = {
    { aes128_set_encrypt_keys, aes128_encrypt_block },
    { aes192_set_encrypt_keys, aes192_encrypt_block },
    { aes256_set_encrypt_keys, aes256_encrypt_block }
};

static block_dispatch   stream_decrypt_dispatch[] = {
    { aes128_set_decrypt_keys, aes128_decrypt_block },
    { aes192_set_decrypt_keys, aes192_decrypt_block },
    { aes256_set_decrypt_keys, aes256_decrypt_block }
};


/*
 * Block operations
 */

static inline uint8_t   unpad_block(aes_block block) {
    uint8_t             pad = block[sizeof(aes_block ) - 1];

    if (pad > 0 && pad < sizeof(aes_block)) {
        for (int i = sizeof(aes_block) - pad; i < sizeof(aes_block); ++i) {
            if (block[i] != pad) {
                goto no_padding;
            }
        }
        return sizeof(aes_block) - pad;
    }
no_padding:
    return sizeof(aes_block);
}


/*
 * Stream operations
 */
void            stream_encrypt(config *cfg) {
    int         size = 1;
    aes_block   block;

    cfg->block_op->set_round_keys(&cfg->key);
    while (1) {
        size = read(STDIN_FILENO, &block, sizeof(block));
        if (size == -1) {
            err(EXIT_FAILURE, "stdin");
        }
        if (size == 0) {
            break;
        }
        if (size < sizeof(block)) {
            uint8_t pad = sizeof(block) - size;
            for (int i = size; i < sizeof(block); ++i) {
                block[i] = pad;
            }
        }
        cfg->block_op->process_block(&block);
        if (write(STDOUT_FILENO, &block, sizeof(block)) == -1) {
            err(EXIT_FAILURE, "stdout");
        }
    }
}

#define SWAP(a, b) { __typeof__(a) _t = a; a = b; b = _t; }
void            stream_decrypt(config *cfg) {
    int         read_block = 0, read_last = 0;
    int         idx = 0, lidx = 1;
    int         size[2];
    aes_block   block[2];

    cfg->block_op->set_round_keys(&cfg->key);
    while (1) {
        size[idx] = read(STDIN_FILENO, block + idx, sizeof(block[0]));
        if (size[idx] == -1) {
            err(EXIT_FAILURE, "stdin");
        }
        if (size[idx] == 0) {
            read_last = 1;
            size[lidx] = unpad_block(block[lidx]);
        }
        if (read_block) {
            if (write(STDOUT_FILENO, block + lidx, size[lidx]) == -1) {
                err(EXIT_FAILURE, "stdout");
            }
        }
        if (read_last) break;
        if (size[idx] != sizeof(block[0])) {
            errx(EXIT_FAILURE, bad_block_length_error_msg);
        }
        cfg->block_op->process_block(block + idx);
        read_block = 1;
        SWAP(idx, lidx);
    }
};


/*
 * Configuration routines
 */
static inline void  fail_if_aes_ni_absent() {
    if (!aes_ni_present())
        errx(EXIT_FAILURE, no_aes_ni_error_msg);
}

static inline void  fail_with_usage(void) {
   fprintf(stderr, usage_msg);
   exit(EXIT_FAILURE);
}

static inline void  fail_if_bad_usage(int argc) {
    if (argc == 3)
        return;
    fail_with_usage();
}

static inline void  fail_if_bad_command(config *cfg, char *cmd) {
    if (strlen(cmd) == 1) {
        switch (cmd[0]) {
            case 'c':
                cfg->op = stream_encrypt;
                cfg->block_op = stream_encrypt_dispatch;
                return;
            case 'd':
                cfg->op = stream_decrypt;
                cfg->block_op = stream_decrypt_dispatch;
                return;
        }
    }
    fail_with_usage();
}

static inline void  read_key_from_file(config *cfg, char *key_filename) {
    uint8_t         key_size;
    FILE            *file;
    struct stat     file_info;

    file = fopen(key_filename, "r");
    if (file == NULL) {
        err(EXIT_FAILURE, "%s", key_filename);
    }
    if (fstat(fileno(file), &file_info) == -1) {
        err(EXIT_FAILURE, "%s", key_filename);
    }
    switch (file_info.st_size) {
        default:
            errx(EXIT_FAILURE, key_size_error_msg);
        case 32:
            cfg->block_op += 1;
        case 24:
            cfg->block_op += 1;
        case 16:
            key_size = file_info.st_size;
    }
    if (fread(&cfg->key[32 - key_size], key_size, 1, file) == -1) {
        err(EXIT_FAILURE, NULL);
    }
    if (fclose(file) == EOF) {
        err(EXIT_FAILURE, "%s", key_filename);
    }
}

static inline void  set_configuration(config *cfg, int argc, char *argv[]) {
    fail_if_bad_usage(argc);
    fail_if_bad_command(cfg, argv[1]);
    read_key_from_file(cfg, argv[2]);
}


/*
 * Stream processing
 */
static inline void  fail_with_tty_input(void) {
    if (isatty(STDIN_FILENO))
        errx(EXIT_FAILURE, tty_input_error_msg);
}

static inline void  process_stream(config *cfg) {
    fail_with_tty_input();
    cfg->op(cfg);
}


/*
 * Main
 */
int         main(int argc, char *argv[]) {
    config  cfg;

    memset(&cfg, 0, sizeof(cfg));
    fail_if_aes_ni_absent();
    set_configuration(&cfg, argc, argv);
    process_stream(&cfg);
    exit(EXIT_SUCCESS);
}
