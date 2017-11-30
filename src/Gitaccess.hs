{-# LANGUAGE BangPatterns    #-}
{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}

module Gitaccess where 

import Control.Monad
--import Data.Vector
import GitHub
import GitHub.Data
import GitHub.Endpoints.Repos.Commits
import Data.Text         (Text, pack)
import GitHub.Internal.Prelude
--import Data.Text.IO
import Prelude
--import qualified GitHub.Repos.Commits as Github

main :: IO ()
main = do
    getCommitList
    --printCommits commits


getCommitList :: IO ()
getCommitList = do 
    tmp <- commitsFor "tensorflow" "haskell" --FetchAll
    case tmp of
        (Left error)    -> putStrLn $ "Error: " ++ (show error)
        (Right commits) -> do
            let tmp = intercalate "\n" $ map formatCommit (toList commits)
            putStrLn tmp
    
formatCommit :: GitHub.Commit -> String
formatCommit commit =
   (show $ GitHub.commitSha commit)


