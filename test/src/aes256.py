import aes


class TestAes256(aes.TestAes):
    def setUp(self):
        #routines signatures
        self.set_encrypt_keys = aes.AesKeyFunc(("aes256_set_encrypt_keys",
                                                aes.aes256))
        self.set_decrypt_keys = aes.AesKeyFunc(("aes256_set_decrypt_keys",
                                                aes.aes256))
        self.encrypt_block = aes.AesBlockFunc(("aes256_encrypt_block",
                                                aes.aes256))
        self.decrypt_block = aes.AesBlockFunc(("aes256_decrypt_block",
                                                aes.aes256))
        self.get_keys = aes.AesRoundKeysFunc(("aes256_get_keys", aes.test_util))
        self.set_keys = aes.AesRoundKeysFunc(("aes_set_keys", aes.test_util))
        #test values
        key, text, cypher = (
            "000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f",
            "00112233445566778899aabbccddeeff",
            "8ea2b7ca516745bfeafc49904b496089")
        encryption_keys = (
            "000102030405060708090a0b0c0d0e0f",
            "101112131415161718191a1b1c1d1e1f",
            "a573c29fa176c498a97fce93a572c09c",
            "1651a8cd0244beda1a5da4c10640bade",
            "ae87dff00ff11b68a68ed5fb03fc1567",
            "6de1f1486fa54f9275f8eb5373b8518d",
            "c656827fc9a799176f294cec6cd5598b",
            "3de23a75524775e727bf9eb45407cf39",
            "0bdc905fc27b0948ad5245a4c1871c2f",
            "45f5a66017b2d387300d4d33640a820a",
            "7ccff71cbeb4fe5413e6bbf0d261a7df",
            "f01afafee7a82979d7a5644ab3afe640",
            "2541fe719bf500258813bbd55a721c0a",
            "4e5a6699a9f24fe07e572baacdf8cdea",
            "24fc79ccbf0979e9371ac23c6d68de36")
        decryption_keys = (
            "000102030405060708090a0b0c0d0e0f",
            "1a1f181d1e1b1c191217101516131411",
            "2a2840c924234cc026244cc5202748c4",
            "7fd7850f61cc991673db890365c89d12",
            "15c668bd31e5247d17c168b837e6207c",
            "aed55816cf19c100bcc24803d90ad511",
            "de69409aef8c64e7f84d0c5fcfab2c23",
            "f85fc4f3374605f38b844df0528e98e1",
            "3ca69715d32af3f22b67ffade4ccd38e",
            "74da7ba3439c7e50c81833a09a96ab41",
            "b5708e13665a7de14d3d824ca9f151c2",
            "c8a305808b3f7bd043274870d9b1e331",
            "5e1648eb384c350a7571b746dc80e684",
            "34f1d1ffbfceaa2ffce9e25f2558016e",
            "24fc79ccbf0979e9371ac23c6d68de36")
        self.key = aes.AesKey(*aes.hex_to_val(key))
        self.text, self.cypher = map(aes.hex_to_block, (text, cypher))
        self.encrypt_round_keys, self.decrypt_round_keys = (
            aes.AesRoundKeys(*aes.hex_list_to_block_list(encryption_keys)),
            aes.AesRoundKeys(*aes.hex_list_to_block_list(decryption_keys)))
