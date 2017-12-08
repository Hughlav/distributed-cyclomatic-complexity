{-# LANGUAGE BangPatterns    #-}
{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE ViewPatterns #-}

module Gitaccess where 

import Control.Monad
import GitHub
import GitHub.Data
import GitHub.Endpoints.Repos.Commits
import Data.Text         (Text, pack, stripSuffix)
import GitHub.Internal.Prelude
import Prelude
import Data.Char
import System.FilePath
import Data.Either
import System.Directory
import System.Process


repository :: Name Repo
repository = "Distributed-file-system"

main :: IO ()
main = do
    shas <- getCommitList
    putStrLn (show shas)
    getRepo
    getCommit "b865e244571d87de626258cb8f8fce3e54a4d70e"
    putStrLn "got that commit"


getCommitList :: IO [Maybe Text] 
getCommitList = do 
    tmp <- commitsFor "Hughlav" repository --FetchAll
    case tmp of
        (Left error)    -> return [Nothing]
        (Right commits) -> do
            let tmp = map formatCommit (toList commits) --intercalate "\n" $
            let shas = map parseString (tmp)
            let tmper = map pack shas
            let newShas = map (stripSuffix "\"")(tmper)
            return newShas
    
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