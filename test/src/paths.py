from os import path


test_dir = path.abspath(path.join(path.dirname(__file__), "test"))
bin_dir = path.join(test_dir, "bin")
shell_bin = path.join(bin_dir, "main")
aes_ni = path.join(bin_dir, "aes_ni.so")
aes128 = path.join(bin_dir, "aes128.so")
aes192 = path.join(bin_dir, "aes192.so")
aes256 = path.join(bin_dir, "aes256.so")
key_helper = path.join(bin_dir, "key_helper.so")
