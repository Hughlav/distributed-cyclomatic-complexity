{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE BangPatterns #-}
{-# LANGUAGE OverloadedStrings #-}
module Main where

import Lib
import           System.CPUTime
import           Text.Printf
import Control.DeepSeq
import Control.Exception
import Formatting
import Formatting.Clock
import System.Clock

main :: IO ()
main = do
    start <- getTime Monotonic
    someFunc
    end <- getTime Monotonic
    fprint (timeSpecs % "\n") start end
