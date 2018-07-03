module CryptoPals where

import           Control.Monad

import qualified Data.ByteString        as B
import qualified Data.ByteString.Char8  as Char8
import qualified Data.ByteString.Base64 as B64
import           Data.Hex (hex, unhex)

import           Data.Bits (xor, popCount)
import           Data.Word (Word8)

import qualified Frequency (count, score, mostCommon, englishLetter)

-- Converts a hex string into a base64 string
hex2base64 :: B.ByteString -> (Maybe B.ByteString)
hex2base64 = (liftM B64.encode) . unhex

fixedXor :: B.ByteString -> B.ByteString -> B.ByteString
fixedXor b1 b2 = B.pack $ B.zipWith (xor) b1 b2

repeatedXor :: B.ByteString -> B.ByteString -> B.ByteString 
repeatedXor key toEncode = fixedXor toEncode (B.concat $ repeat key)

singleByteXor :: Word8 -> B.ByteString -> B.ByteString
singleByteXor k = B.map (xor k)
 
hammingDistance :: B.ByteString -> B.ByteString -> Int
hammingDistance b1 b2 = B.foldr (\w sum -> (popCount w) + sum) 0 $ fixedXor b1 b2

--bestSingleByteXor :: B.ByteString -> Word8
bestSingleByteXor bs = snd $ B.foldr (collectBest) (0, []) Frequency.englishLetter
    where
        mc = Frequency.mostCommon bs
        getScore b want = Frequency.score 
                            Frequency.englishLetter 
                            $ singleByteXor (b `xor` want) bs
        collectBest w (s, b) = let score = getScore mc w in
                           if score > s then (score, mc `xor` w:b) else (s, b)

