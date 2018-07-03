#!/usr/bin/ptpython -i

import importlib

import cryptopals
from cryptopals import *

def reload():
    return importlib.reload(cryptopals)


