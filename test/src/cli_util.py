import tempfile
import subprocess
import paths


def create_key_file(content):
    file = tempfile.NamedTemporaryFile(bufsize=0)
    file.write(content)
    return file

def run_process(msg=None, *kargs):
    args = [paths.shell_bin] + list(kargs)
    proc = subprocess.Popen(args, stdin=subprocess.PIPE,
                            stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    out, err = proc.communicate(msg)
    return proc.returncode, out, err
