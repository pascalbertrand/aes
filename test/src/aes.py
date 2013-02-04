import ctypes
import unittest

import paths


#Import assembly libraries
aes_ni = ctypes.cdll.LoadLibrary(paths.aes_ni)
aes128 = ctypes.cdll.LoadLibrary(paths.aes128)
aes192 = ctypes.cdll.LoadLibrary(paths.aes192)
aes256 = ctypes.cdll.LoadLibrary(paths.aes256)
test_util = ctypes.cdll.LoadLibrary(paths.key_helper)


#Detect AES-NI instruction set support
aes_ni_present = bool(aes_ni.aes_ni_present())


#Aes types
AesBlock = ctypes.c_uint8 * 16
AesKey = ctypes.c_uint8 * 32
AesRoundKeys = AesBlock * 15
AesBlockFunc = ctypes.CFUNCTYPE(None, AesBlock)
AesKeyFunc = ctypes.CFUNCTYPE(None, AesKey)
AesRoundKeysFunc = ctypes.CFUNCTYPE(None, AesRoundKeys)


def aes_types_repr(self):
    return ' '.join(["{:02x}".format(elt) for elt in self])

AesBlock.__repr__ = AesKey.__repr__ = aes_types_repr


def aes_round_keys_repr(self):
    return '\n' + '\n'.join([str(elt) for elt in self]) + '\n'

AesRoundKeys.__repr__ = aes_round_keys_repr


def aes_types_eq(self, other):
    if len(self) == len(other):
        for i in xrange(len(self)):
            if self[i] != other[i]:
                break
        else:
            return True
    return False

AesKey.__eq__ = AesBlock.__eq__ = AesRoundKeys.__eq__ = aes_types_eq


def aes_types_ne(self, other):
    return not aes_types_eq(self, other)

AesKey.__ne__ = AesBlock.__ne__ = AesRoundKeys.__ne__ = aes_types_ne


#Simple constructors for AesKey, AesBlock, and AesRoundKeys
def hex_to_val(str):
    return bytearray(str.decode('hex'))


def hex_to_key(hex):
    return AesKey(*hex_to_val(hex))


def hex_to_block(hex):
    return AesBlock(*hex_to_val(hex))


def hex_list_to_block_list(l):
    return map(hex_to_block, l)


@unittest.skipUnless(aes_ni_present,
                     "Your processor does not support aes-ni instructions")
class TestAes(unittest.TestCase):
    """General TestCase for AES tests.

    Inherit and define values for key, text, cypher, encrypt_round_keys,
    and decrypt_round_keys
    """
    def test_Aes_encrypt_keygen(self):
        round_keys = AesRoundKeys()
        self.set_encrypt_keys(self.key)
        self.get_keys(round_keys)
        self.assertEqual(round_keys, self.encrypt_round_keys)

    def test_Aes_decrypt_keygen(self):
        round_keys = AesRoundKeys()
        self.set_decrypt_keys(self.key)
        self.get_keys(round_keys)
        self.assertEqual(round_keys, self.decrypt_round_keys)

    def test_Aes_encrypt_block(self):
        block = AesBlock(*self.text)
        self.set_keys(self.encrypt_round_keys)
        self.encrypt_block(block)
        self.assertEqual(block, self.cypher)

    def test_Aes_decrypt_block(self):
        block = AesBlock(*self.cypher)
        self.set_keys(self.decrypt_round_keys)
        self.decrypt_block(block)
        self.assertEqual(block, self.text)
