import unittest
import cli_util


class TestPadding(unittest.TestCase):
    def test_program_does_not_pad_complete_block(self):
        key = cli_util.create_key_file("0123456789abcdef")
        msg = "fedcba9876543210"
        status, block, err = cli_util.run_process(msg, 'c', key.name)
        self.assertEqual(block, msg)

    def test_program_pads_uncomplete_block(self):
        key = cli_util.create_key_file("0123456789abcdef")
        msg, expected = "9876543210", "9876543210\x06\x06\x06\x06\x06\x06"
        status, block, err = cli_util.run_process(msg, 'c', key.name)
        self.assertEqual(block, expected)

    def test_program_does_not_unpad_non_padded_block(self):
        key = cli_util.create_key_file("0123456789abcdef")
        msg = "fdecba9876543210"
        status, block, err = cli_util.run_process(msg, 'd', key.name)
        self.assertEqual(block, msg)

    def test_program_unpads_padded_block(self):
        key = cli_util.create_key_file("0123456789abcdef")
        msg = "9876543210\x06\x06\x06\x06\x06\x06"
        expected = msg[:-6]
        status, block, err = cli_util.run_process(msg, 'd', key.name)
        self.assertEqual(block, expected, err)

    def test_program_only_unpads_last_block(self):
        key = cli_util.create_key_file("0123456789abcdef")
        msg = "9876543210\x06\x06\x06\x06\x06\x06" * 2
        expected = msg[:-6]
        status, out, err = cli_util.run_process(msg, 'd', key.name)
        self.assertEqual(out, expected, err)
