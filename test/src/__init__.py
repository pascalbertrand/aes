import unittest

import aes128
import aes192
import aes256
import cli
import padding


test_cases = (
    cli.TestCLI,
    padding.TestPadding,
    aes128.TestAes128,
    aes192.TestAes192,
    aes256.TestAes256,
)


def load_tests(loader, tests, pattern):
    suite = unittest.TestSuite()
    for test_case in test_cases:
        suite.addTests(loader.loadTestsFromTestCase(test_case))
    return suite
