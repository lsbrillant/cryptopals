module Printer where 

data Test = Test { testName :: String, result :: Bool }

prettyPrint :: Test -> String
prettyPrint (Test{testName=n,result=r}) = n ++ ": " ++ status 
    where status = if r then "Passed" else "Failed"

pp ts = foldl (\a t -> a ++ "\t" ++ (prettyPrint t) ++ "\n" ) "" betterTs
     where maxLen = foldr (max) 0 $ map (length . testName) ts
           betterTs = map (\t -> t {testName= rpad (maxLen+1) (testName t)}) ts 
           rpad m s = take m $ s ++ (concat $ repeat " ")

data TestSuite = TestSuite { suiteName :: String, tests :: [Test] } 

instance Show TestSuite where
    show (TestSuite {suiteName=n,tests=ts}) = n ++ ":\n" ++ (pp ts)
