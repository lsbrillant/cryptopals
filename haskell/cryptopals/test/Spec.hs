module Main where

import qualified Data.ByteString as B
import qualified Data.ByteString.Char8 as Char8 (pack)
import           Data.Hex (hex, unhex)

import CryptoPals
import qualified Set1 (main)


main :: IO ()
main = do
        putStrLn $ ""
        Set1.main

