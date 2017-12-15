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
--import Data.ByteString.Lazy.Char8 as B8 hiding (putStrLn, map, words)
--import qualified Data.ByteString.Lazy as B
import Data.Aeson
import Data.Aeson.TH (deriveJSON, defaultOptions)
import Control.Monad.IO.Class
import Data.Maybe
import System.IO.Unsafe

data ListCommits = ListCommits {
    
}
data Commits = Commits {
      blocks :: [Block]
    , path  :: !Text
    , types :: !Text
    } deriving (Generic, FromJSON, ToJSON, Show)

data Block = Block {
      complexity :: Int
    , name :: !Text
    , lineno :: Int
    , col :: Int
} deriving (Generic, FromJSON, ToJSON, Show)


-- instance FromJSON Commits
-- instance ToJSON Commits

repository :: Name Repo
repository = "Distributed-file-system"

-- main :: IO ()
-- main = do
--     shas <- getCommitList
--     putStrLn (show shas)
--     getRepo
--     result <- workerWork "f8446f6f8b6a20a248fe07ebd9b8ee1bf04498c8"
--     putStrLn (show result)
-- --     getRepo
--     getCommit "2470599e7205a9a3fcd544bfe7259f932ca0a68d"
--     putStrLn "got that commit"
--     result <- runArgon "Distributed-file-system"
--     putStrLn result



workerWork :: String -> IO Integer
workerWork commit = do
    getCommit commit
    result <- runArgon "Distributed-file-system"
    --putStrLn (result)
    sumComplexity result
    


-- initaliseWorker :: IO()
-- initaliseWorker = do
--     getRepo

getCommitList :: IO [String] 
getCommitList = do 
    tmp <- commitsFor "Hughlav" repository --FetchAll
    case tmp of
        (Left error)    -> return [" "]
        (Right commits) -> do
            let tmp = map formatCommit (toList commits) --intercalate "\n" $
            let shas = map parseString (tmp)
            let tmper = map GitHub.Internal.Prelude.pack shas
            let newShas = map (Data.Text.stripSuffix "\"")(tmper)
            let shaList = map fromJust newShas
            let final = map Data.Text.unpack (shaList)
            return final
    
numCommits :: [String] -> IO Int 
numCommits commits = do
    return (length commits)

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
    exist <- doesDirectoryExist "Distributed-file-system"
    if exist
        then do
            removeDirectoryRecursive "Distributed-file-system"
            callProcess "git" ["clone", "https://github.com/Hughlav/Distributed-file-system.git"]
        else 
            callProcess "git" ["clone", "https://github.com/Hughlav/Distributed-file-system.git"]

getCommit :: String -> IO String
getCommit commit = do
    readCreateProcess ((proc "git" ["reset","--hard",commit]){ cwd = Just "Distributed-file-system"}) ""

runArgon :: String -> IO String
runArgon filePath = do
    let command = "exec -- argon --no-color "++filePath
    (_,Just out, _, procHandle) <- createProcess (proc "stack" $ words command) { std_out = CreatePipe }
    waitForProcess procHandle
    hGetContents out

sumComplexity :: String -> IO Integer
sumComplexity result = do
    let lineList = lines result
    --putStrLn $ "total lines are: " ++ (show lineList)
    let complex = map (\a -> returnComplex a) lineList
    let listComplex = map unsafePerformIO complex
    return (sum listComplex)
    --complexity
    


returnComplex :: String -> IO Integer
returnComplex line = do
    --putStrLn $ "line: " ++ line
    case words line of
        [_,_,_,n] -> do
            --putStrLn $ "n = " ++ (show n)
            return (read n)
        [_,_] -> do 
            let intN = 0 :: Integer
            return intN
        [_] -> do
            --putStrLn $ "line = " ++ (line)
            let intN = 0 :: Integer
            return intN
        [_,_,_,_,_,_,_] -> do
            --putStrLn $ "line = " ++ (line)
            let intN = 0 :: Integer
            return intN

