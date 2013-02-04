import aes


class TestAes128(aes.TestAes):
    def setUp(self):
        #routines signatures
        self.set_encrypt_keys = aes.AesKeyFunc(("aes128_set_encrypt_keys",
                                                aes.aes128))
        self.set_decrypt_keys = aes.AesKeyFunc(("aes128_set_decrypt_keys",
                                                aes.aes128))
        self.encrypt_block = aes.AesBlockFunc(("aes128_encrypt_block",
                                                aes.aes128))
        self.decrypt_block = aes.AesBlockFunc(("aes128_decrypt_block",
                                                aes.aes128))
        self.get_keys = aes.AesRoundKeysFunc(("aes128_get_keys", aes.test_util))
        self.set_keys = aes.AesRoundKeysFunc(("aes_set_keys", aes.test_util))
        #test values
        key, text, cypher = (
            "000102030405060708090a0b0c0d0e0f",
            "00112233445566778899aabbccddeeff",
            "69c4e0d86a7b0430d8cdb78070b4c55a")
        encryption_keys = (
            "000102030405060708090a0b0c0d0e0f",
            "d6aa74fdd2af72fadaa678f1d6ab76fe",
            "b692cf0b643dbdf1be9bc5006830b3fe",
            "b6ff744ed2c2c9bf6c590cbf0469bf41",
            "47f7f7bc95353e03f96c32bcfd058dfd",
            "3caaa3e8a99f9deb50f3af57adf622aa",
            "5e390f7df7a69296a7553dc10aa31f6b",
            "14f9701ae35fe28c440adf4d4ea9c026",
            "47438735a41c65b9e016baf4aebf7ad2",
            "549932d1f08557681093ed9cbe2c974e",
            "13111d7fe3944a17f307a78b4d2b30c5")
        decryption_keys = (
            "000102030405060708090a0b0c0d0e0f",
            "8c56dff0825dd3f9805ad3fc8659d7fd",
            "a0db02992286d160a2dc029c2485d561",
            "c7c6e391e54032f1479c306d6319e50c",
            "a8a2f5044de2c7f50a7ef79869671294",
            "2ec410276326d7d26958204a003f32de",
            "72e3098d11c5de5f789dfe1578a2cccb",
            "8d82fc749c47222be4dadc3e9c7810f5",
            "1362a4638f2586486bff5a76f7874a83",
            "13aa29be9c8faff6f770f58000f7bf03",
            "13111d7fe3944a17f307a78b4d2b30c5")
        self.key = aes.AesKey(*aes.hex_to_val(key))
        self.text, self.cypher = map(aes.hex_to_block, (text, cypher))
        self.encrypt_round_keys, self.decrypt_round_keys = (
            aes.AesRoundKeys(*aes.hex_list_to_block_list(encryption_keys)),
            aes.AesRoundKeys(*aes.hex_list_to_block_list(decryption_keys)))
