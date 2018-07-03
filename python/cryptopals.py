import codecs
import operator
import math
import itertools
import collections

from colorama import Fore, Style

chal1_string = '49276d206b696c6c696e6720796f757220627261696e206c696b65206120706f69736f6e6f7573206d757368726f6f6d'

b64_alphabet='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/' 

def b64encode(bytestring, alphabet=b64_alphabet):
    """ Super shitty base 64 encode, doesnt work FIXME """ 
    result = bytes()
    while bytestring:
        triplet = int.from_bytes(bytestring[0:3],'little')
        result += bytes((triplet >> offs) & 63 for offs in range(18,-1,-6))
        bytestring = bytestring[3:]
        print(bytestring)

    string = ''
    for b in result:
        string += alphabet[b]
    print(string)
    return result

def hex2b64(hex_string):
    return codecs.encode(hex_decode(hex_string), 'base64')

def hex_decode(hex_string):
    return codecs.decode(hex_string, 'hex')

def fixed_xor(b1, b2):
    return bytes(x^y for (x,y) in zip(b1,b2)) 

def single_byte_xor(s):
    best_score = -1
    best_xor = b'\x00'
    byte, num = collections.Counter(s).most_common().pop()
    for ch in english_letter_frequency.encode():
        xored = ch ^ byte
        score = letter_frequency_score(
                    fixed_xor(s, itertools.repeat(ch ^ byte))
                )
        if score > best_score:
            best_score = score
            best_xor = xored 
    return best_xor

def bit_count(int_type):
    count = 0
    while int_type:
        int_type &= int_type -1
        count +=1
    return count

def hamming_distance(b1,b2):
    xored = int.from_bytes(b1,'little') ^ int.from_bytes(b2,'little')
    return bit_count(xored)

english_letter_frequency = 'etaoilnshrdlcumwfgypbvkjxqz'
english_letter_frequency += ' '+english_letter_frequency.upper()
english_letter_frequency += ',.\'\n'
english_letter_frequency += '0123456789'
 
def letter_frequency_score(bytestring, letter_frequency=english_letter_frequency):
    counts = collections.Counter(bytestring)
    frequency = letter_frequency[::-1] # reverse it 
    score = 0
    for b, count in counts.items():
        try:
            score += count * frequency.index(chr(b))
        except:
            pass
    return score / len(bytestring)

def repeated_xor(bytestring, key):
    repeated_key = itertools.repeat(key, (len(bytestring) // len(key))+1)
    return fixed_xor(bytestring,
            itertools.chain(*repeated_key))

def chal_6():
    with open("6.txt", 'r') as f:
        data = f.read()
        encoded = codecs.decode(''.join(data.splitlines()).encode(),'base64')
    ans = statistcaly_break_repeated_xor(encoded)
    print("Key: " + ans[0].decode() + "\nPlaintext: \n" + ans[1].decode())

def statistcaly_break_repeated_xor(encoded, top=1, keymax=40, debug=False):
    hams = []
    for x in range(2,keymax+1):
        ham = sum(
            hamming_distance(a,b)/x for a,b in 
            itertools.permutations((encoded[i:i+x] for i in range(0,x*4,x)), 2)
            ) / 24
        hams.append((ham, x))
    hams.sort(key=lambda t: t[0])
    best = []
    for x, key_size in hams[0:top]:
        blocks = [ bytearray() for x in range(key_size) ]
        for i, b in enumerate(encoded):
            blocks[i%key_size].append(b)

        best_fit = bytearray(key_size)
        for i, block in enumerate(blocks):
            best_fit[i] = single_byte_xor(block)
        if debug:
            print(best_fit.decode())
            print(Fore.RED + str(key_size) + Style.RESET_ALL,
                    repeated_xor(encoded, best_fit).decode())
        best.append((best_fit, repeated_xor(encoded, best_fit)))
    if top == 1:
        return best.pop()
    else:
        return best

from hashlib import md5
from Crypto.Cipher import AES


# Padding for the input string --not
# related to encryption itself.
BLOCK_SIZE = AES.block_size  # Bytes
pad = lambda s: s + (BLOCK_SIZE - len(s) % BLOCK_SIZE) * \
                chr(BLOCK_SIZE - len(s) % BLOCK_SIZE)
unpad = lambda s: s[:-ord(s[len(s) - 1:])]

"""
class AESCipher:
    """
    #Usage:
    #    c = AESCipher('password').encrypt('message')
    #    m = AESCipher('password').decrypt(c)
    #Tested under Python 3 and PyCrypto 2.6.1.
    """

    def __init__(self, key):
        self.key = key.encode('utf8')

    def encrypt(self, raw):
        raw = pad(raw)
        cipher = AES.new(self.key, AES.MODE_ECB)
        return codecs.encode(cipher.encrypt(raw), 'base64')

    def decrypt(self, enc):
        enc = codecs.decode(enc, 'base64')
        cipher = AES.new(self.key, AES.MODE_ECB)
        return unpad(cipher.decrypt(enc)).decode('utf8')
"""

def chal_7():
    with open("7.txt", 'r') as f:
        data = ''.join(f.read().splitlines()).encode()
        cipher = AESCipher("YELLOW SUBMARINE")
        print(cipher.decrypt(data))

def ecb_search():
    with open('8.txt', 'r') as f:
        for line in f.read().splitlines():
            enc = codecs.decode(line, 'hex')
            if detect_ecb(enc):
                print(line)

def detect_ecb(bytestring):
    i = 0
    could_repeat = [ x for x in range(0, len(bytestring), AES.block_size) ] 
    repeaded = False
    while i < AES.block_size:
        repeaded = False
        bytes_with_this_index = bytearray(bytestring[x+i] for x in could_repeat)
        to_remove = []
        for index, b in enumerate(bytes_with_this_index):
            bs = bytes_with_this_index.copy()
            bs.remove(b)
            if b in bs:
                repeaded = True
            else:
                to_remove.append(could_repeat[index])
        for r in to_remove:
            could_repeat.remove(r)
        if not repeaded:
            break
        i += 1
    else: 
        return True
    return False


class AESCipher:
    def addRoundKey():
        return 
    def InvMixColumns():
        return 
    def InvShiftRows():
        return
    def InvSubBytes():
        return



