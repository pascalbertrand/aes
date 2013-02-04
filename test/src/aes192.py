import aes


class TestAes192(aes.TestAes):
    def setUp(self):
        #routines signatures
        self.set_encrypt_keys = aes.AesKeyFunc(("aes192_set_encrypt_keys",
                                                aes.aes192))
        self.set_decrypt_keys = aes.AesKeyFunc(("aes192_set_decrypt_keys",
                                                aes.aes192))
        self.encrypt_block = aes.AesBlockFunc(("aes192_encrypt_block",
                                               aes.aes192))
        self.decrypt_block = aes.AesBlockFunc(("aes192_decrypt_block",
                                               aes.aes192))
        self.get_keys = aes.AesRoundKeysFunc(("aes192_get_keys", aes.test_util))
        self.set_keys = aes.AesRoundKeysFunc(("aes_set_keys", aes.test_util))
        #test values
        key, text, cypher = (
            "000102030405060708090a0b0c0d0e0f1011121314151617",
            "00112233445566778899aabbccddeeff",
            "dda97ca4864cdfe06eaf70a0ec0d7191")
        encryption_keys = (
            "000102030405060708090a0b0c0d0e0f",
            "10111213141516175846f2f95c43f4fe",
            "544afef55847f0fa4856e2e95c43f4fe",
            "40f949b31cbabd4d48f043b810b7b342",
            "58e151ab04a2a5557effb5416245080c",
            "2ab54bb43a02f8f662e3a95d66410c08",
            "f501857297448d7ebdf1c6ca87f33e3c",
            "e510976183519b6934157c9ea351f1e0",
            "1ea0372a995309167c439e77ff12051e",
            "dd7e0e887e2fff68608fc842f9dcc154",
            "859f5f237a8d5a3dc0c02952beefd63a",
            "de601e7827bcdf2ca223800fd8aeda32",
            "a4970a331a78dc09c418c271e3a41d5d")
        decryption_keys = (
            "000102030405060708090a0b0c0d0e0f",
            "1a1f181d1e1b1c194742c7d74949cbde",
            "4b4ecbdb4d4dcfda5752d7c74949cbde",
            "60dcef10299524ce62dbef152f9620cf",
            "78c4f708318d3cd69655b701bfc093cf",
            "dd1b7cdaf28d5c158a49ab1dbbc497cb",
            "c6deb0ab791e2364a4055fbe568803ab",
            "dcc1a8b667053f7dcc5c194ab5423a2e",
            "1147659047cf663b9b0ece8dfc0bf1f0",
            "f77d6ec1423f54ef5378317f14b75744",
            "8fb999c973b26839c7f9d89d85c68c72",
            "d6bebd0dc209ea494db073803e021bb9",
            "a4970a331a78dc09c418c271e3a41d5d")
        self.key = aes.AesKey(*aes.hex_to_val(key))
        self.text, self.cypher = map(aes.hex_to_block, (text, cypher))
        self.encrypt_round_keys, self.decrypt_round_keys = (
            aes.AesRoundKeys(*aes.hex_list_to_block_list(encryption_keys)),
            aes.AesRoundKeys(*aes.hex_list_to_block_list(decryption_keys)))
