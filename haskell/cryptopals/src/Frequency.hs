module Frequency where

import qualified Data.ByteString        as B
import qualified Data.ByteString.Char8  as Char8
import qualified Data.Map.Strict    as Map

import           Data.Word
import           Data.Char (toUpper)
import           Data.List (sortBy)


-- distance between bytes and their expected frequency

--class Element a where
    -- |  
--    fequencyOf :: a -> B.ByteString -> Int
--    bytelength :: a -> Int
    

--instance Element Word8 where
--    feqOf w = B.foldr (\b total-> if b == w then total+1 else total) 0
--    bytelength = const 1

--data Frequency [Element a]

--score :: Frequency -> B.ByteString -> Int

count ::  B.ByteString -> Map.Map Word8 Int
count = B.foldr (upsert) Map.empty
    where upsert w m = if Map.member w m 
                         then Map.update (\count -> Just $ count+1) w m
                         else Map.insert w 1 m  
                       
frequencyOf bs = B.pack $ map (fst) $ reverse $ sortBy (compareCounts) $ byteFreqs 
    where byteFreqs = Map.toList $ count bs
          compareCounts (_, count1) (_, count2) = compare count1 count2

mostCommon :: B.ByteString -> Word8
mostCommon s = B.index (frequencyOf s) 0

englishLetter :: B.ByteString
englishLetter = B.reverse $ Char8.pack $ " etaoilnshrdlcumwfgypbvkjxqz"
                         ++ ".,-'\""
                         ++ (map toUpper "etaoilnshrdlcumwfgypbvkjxqz")
                         ++ "()!&%@"
                         ++ "0987654321"   

score :: B.ByteString -> B.ByteString -> Double
score frequency bs = (fromIntegral totalScore) / bytelength 
    where bytelength = (fromIntegral $ B.length bs)
          totalScore = B.foldr (\w sum -> case B.elemIndex w frequency of 
                                               Just score -> score + sum
                                               Nothing    -> sum) 0 bs

{-
score2 :: B.ByteString -> B.ByteString -> Double
score2 frequency bs = 
    where v bstr freq = map (\Just b -> b)
                      $ filter (isJust) 
                      $ map (\b -> B.elemIndex b freq) 
                      $ B.unpack bstr
          bsFreq = frequencyOf (append bs frequency)
-}         


data EnglishLetterFrequency = EnglishLetterFrequency
    deriving (Show)

class Frequency feq subject where
    placement :: feq -> subject -> Int

instance Frequency EnglishLetterFrequency Word8 where
    placement :: EnglishLetterFrequency -> Word8 -> Int
    placement EnglishLetterFrequency 'e' = 255
    placement EnglishLetterFrequency 't' = 254
    placement EnglishLetterFrequency 'a' = 253

