#include "aes.h"

int     aes_ni_present(void) { return 1; };

void    aes128_set_encrypt_keys(aes_key * key) {}
void    aes128_set_decrypt_keys(aes_key * key) {}

void    aes192_set_encrypt_keys(aes_key * key) {}
void    aes192_set_decrypt_keys(aes_key * key) {}

void    aes256_set_encrypt_keys(aes_key * key) {}
void    aes256_set_decrypt_keys(aes_key * key) {}

void    aes128_encrypt_block(aes_block * block) {}
void    aes128_decrypt_block(aes_block * block) {}

void    aes192_encrypt_block(aes_block * block) {}
void    aes192_decrypt_block(aes_block * block) {}

void    aes256_encrypt_block(aes_block * block) {}
void    aes256_decrypt_block(aes_block * block) {}

