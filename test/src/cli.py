import unittest
import cli_util


class TestCLI(unittest.TestCase):
    def test_program_fail_with_no_args(self):
        status, _, _ = cli_util.run_process()
        self.assertEqual(status, 1)

    def test_program_fail_with_wrong_command(self):
        key = cli_util.create_key_file('0123456789abcdef')
        status, _, _ = cli_util.run_process('c', key.name)
        self.assertEqual(status, 1)

    def test_program_fail_with_bad_key_size(self):
        key = cli_util.create_key_file('0123456789')
        status, _, _ = cli_util.run_process('c', key.name)
        self.assertEqual(status, 1)
