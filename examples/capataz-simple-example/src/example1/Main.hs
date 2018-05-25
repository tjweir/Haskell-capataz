{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
module Main where

import qualified Prelude
import RIO

import Lib
    (Cli (..), killNumberProcess, procNumber, spawnNumbersProcess)
import Options.Generic          (getRecord)


main :: IO ()
main = do
  n <- getRecord "Counter spawner"

  let numberWriter i a = Prelude.print (i, a)
      delayMicros = 5000100

  _asyncList <- forM [1 .. procNumber n]
    $ \i -> async $ spawnNumbersProcess (numberWriter i)

  killerAsync <- async $ forever $ threadDelay delayMicros >> killNumberProcess

  wait killerAsync
