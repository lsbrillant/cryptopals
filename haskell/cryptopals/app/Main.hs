module Main where

import qualified Data.ByteString as B
import qualified Data.ByteString.Char8 as Char8 (pack, putStrLn)


import CryptoPals


main :: IO ()
main = Char8.putStrLn $ case maybeB64 of 
                        Just b64str -> b64str
                        Nothing     -> Char8.pack "Something went wrong"
    where
        maybeB64 = hex2base64 $ Char8.pack "deadbeef"
