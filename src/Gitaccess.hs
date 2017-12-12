{-# LANGUAGE BangPatterns    #-}
{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE ViewPatterns #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DeriveAnyClass #-}

module Gitaccess where 

import Control.Monad
import GitHub
import GitHub.Data hiding (FromJSON)
import GitHub.Endpoints.Repos.Commits
import Data.Text         (Text, pack, stripSuffix, unpack)
import GitHub.Internal.Prelude
import Prelude
import Data.Char
import System.FilePath
import Data.Either
import System.Directory
import System.Process
import System.IO
import GHC.Generics
import Data.ByteString.Lazy.Char8 as B8 hiding (putStrLn, map, words, hGetContents)
import qualified Data.ByteString.Lazy as B
import Data.Aeson
import Control.Monad.IO.Class
import Data.Maybe

data Commits = Commits {
      block :: Block
    , path  :: !Text
    , types :: !Text
    } deriving (Generic, FromJSON, Show)

data Block = Block {
      complexity :: Int
    , name :: !Text
    , lineno :: Int
    , col :: Int
} deriving (Generic, FromJSON, Show)

-- instance FromJSON Commits
-- instance ToJSON Commits

repository :: Name Repo
repository = "Distributed-file-system"

-- main :: IO ()
-- main = do
--     shas <- getCommitList
--     putStrLn (show shas)
--     getRepo
--     getCommit "cf609c0dd7f2ca4da9cf85a7b11babf24c0a1832"
--     putStrLn "got that commit"
--     result <- runArgon "Distributed-file-system"
--     putStrLn result



workerWork :: String -> IO String
workerWork commit = do
    getCommit commit
    runArgon "Distributed-file-system"

initaliseWorker :: IO()
initaliseWorker = do
    getRepo

getCommitList :: IO [String] 
getCommitList = do 
    tmp <- commitsFor "Hughlav" repository --FetchAll
    case tmp of
        (Left error)    -> return [" "]
        (Right commits) -> do
            let tmp = map formatCommit (toList commits) --intercalate "\n" $
            let shas = map parseString (tmp)
            let tmper = map GitHub.Internal.Prelude.pack shas
            let newShas = map (stripSuffix "\"")(tmper)
            let shaList = map fromJust newShas
            let final = map Data.Text.unpack (shaList)
            return final
    
formatCommit :: GitHub.Commit -> String
formatCommit commit =
   (show $ GitHub.commitSha commit)

parseString :: [Char] -> [Char]
parseString ('N':xs) = parseString xs
parseString (' ':xs) = parseString xs
parseString ('"':xs) = parseString xs
parseString xs = xs   

getRepo :: IO()
getRepo = do
    callProcess "git" ["clone", "https://github.com/Hughlav/Distributed-file-system.git"]

getCommit :: String -> IO String
getCommit commit = do
    readCreateProcess ((proc "git" ["reset","--hard",commit]){ cwd = Just "Distributed-file-system"}) ""

runArgon :: String -> IO String
runArgon filePath = do
    let command = "exec -- argon --json "++filePath
    (_,Just out, _, procHandle) <- createProcess (proc "stack" $ words command) { std_out = CreatePipe }
    waitForProcess procHandle
    hGetContents out

-- decodeJSON :: String ->IO ()
-- decodeJSON result = do
--     d <- (eitherDecode (B8.pack result)) :: IO (Either String Commits)
--     case d of
--         Left err -> putStrLn err
--         Right ps -> putStrLn (show d)
