module Set1 where 

import qualified Data.ByteString as B
import qualified Data.ByteString.Char8 as Char8 (pack)
import           Data.Hex (hex, unhex)
import           Data.Bits (xor)

import CryptoPals
import Printer
import Frequency

chal1 = myResult == expectedResult 
    where
        Just myResult = hex2base64 $ Char8.pack "49276d206b696c6c696e6720796f757220627261696e206c696b65206120706f69736f6e6f7573206d757368726f6f6d"
        expectedResult = Char8.pack "SSdtIGtpbGxpbmcgeW91ciBicmFpbiBsaWtlIGEgcG9pc29ub3VzIG11c2hyb29t"

chal2 = fixedXor b1 b2 == expected
    where
        Just b1 = unhex $ Char8.pack "1c0111001f010100061a024b53535009181c"
        Just b2 = unhex $ Char8.pack "686974207468652062756c6c277320657965"
        Just expected = unhex $ Char8.pack "746865206b696420646f6e277420706c6179"

hammTest = hammingDistance (Char8.pack "this is a test") (Char8.pack "wokka wokka!!!") == 37


chal3 = singleByteXor best text == Char8.pack "Cooking MC's like a pound of bacon"
    where best:_ = bestSingleByteXor text 
          Just text = unhex $ Char8.pack "1b37373331363f78151b7f2b783431333d78397828372d363c78373e783a393b3736"


suite = TestSuite
        { suiteName = "Set 1"
        , tests = [
            Test 
            { testName = "Chal 1, Convert hex to base64"
            , result = chal1 },
            Test 
            { testName = "Chal 2, fixed xor"
            , result = chal2 },
            Test 
            { testName = "Chal 3, break single byte xor"
            , result = chal2 },  
            Test 
            { testName = "Hamming distance"
            , result = hammTest } ]
        }

main :: IO ()
main = do
        putStr $ show suite

