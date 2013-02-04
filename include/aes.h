#include <stdint.h>

/*
 * This module provides routines using Intel AES-NI instructions on Intel x64.
 *
 * aes_key represents an AES key.
 * For a 128 bits key write bytes 0 to 15.
 * For a 192 bits key write bytes 0 to 23.
 * For a 256 bits key write bytes 0 to 31.
 *
 * aes_block represents an AES block of 16 bytes, from 0 to 15.
 *
 * Before using AES routines, use aes_ni_present to check if your processor
 * supports AES-NI instructions.
 *
 * To process blocks:
 *
 * 1. Set aes rounds keys by passing the key to the appropriate
 *    set_encrypt_keys or set_decrypt_keys.
 * 2. Call the associated encrypt_block or decrypt_block routine for every
 *    block.
 *
 *
 * WARNING!
 *
 * set_encrypt_keys and set_decrypt_keys routines compute and setup keys in
 * SSE registers. DO NOT modify SSE registers between a call to a set_*_keys
 * and calls to the associated *_block routine.
 *
 */


/* Types */
typedef uint8_t aes_key[32] __attribute__ ((aligned (16)));
typedef uint8_t aes_block[16] __attribute__ ((aligned (16)));

/* AES isntructions support */
int aes_ni_present(void);

/* AES 128 */
void aes128_set_encrypt_keys(aes_key *);
void aes128_encrypt_block(aes_block *);

void aes128_set_decrypt_keys(aes_key *);
void aes128_decrypt_block(aes_block *);

/* AES 192 */
void aes192_set_encrypt_keys(aes_key *);
void aes192_encrypt_block(aes_block *);

void aes192_set_decrypt_keys(aes_key *);
void aes192_decrypt_block(aes_block *);

/* AES 256 */
void aes256_set_encrypt_keys(aes_key *);
void aes256_encrypt_block(aes_block *);

void aes256_set_decrypt_keys(aes_key *);
void aes256_decrypt_block(aes_block *);

