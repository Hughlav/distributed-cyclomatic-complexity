module Paths_use_cloudhaskell (
    version,
    getBinDir, getLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where

import qualified Control.Exception as Exception
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude

catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
catchIO = Exception.catch

version :: Version
version = Version [0,1,0,0] []
bindir, libdir, datadir, libexecdir, sysconfdir :: FilePath

bindir     = "/Users/HughLavery/Documents/College/Year 4/CS4400/distributed-cyclomatic-complexity/.stack-work/install/x86_64-linux-dkda49f7ca9b244180d3cfb1987cbc9743/lts-3.22/7.10.2/bin"
libdir     = "/Users/HughLavery/Documents/College/Year 4/CS4400/distributed-cyclomatic-complexity/.stack-work/install/x86_64-linux-dkda49f7ca9b244180d3cfb1987cbc9743/lts-3.22/7.10.2/lib/x86_64-linux-ghc-7.10.2/use-cloudhaskell-0.1.0.0-LbyoIXb6p756ZYzHnVxUNm"
datadir    = "/Users/HughLavery/Documents/College/Year 4/CS4400/distributed-cyclomatic-complexity/.stack-work/install/x86_64-linux-dkda49f7ca9b244180d3cfb1987cbc9743/lts-3.22/7.10.2/share/x86_64-linux-ghc-7.10.2/use-cloudhaskell-0.1.0.0"
libexecdir = "/Users/HughLavery/Documents/College/Year 4/CS4400/distributed-cyclomatic-complexity/.stack-work/install/x86_64-linux-dkda49f7ca9b244180d3cfb1987cbc9743/lts-3.22/7.10.2/libexec"
sysconfdir = "/Users/HughLavery/Documents/College/Year 4/CS4400/distributed-cyclomatic-complexity/.stack-work/install/x86_64-linux-dkda49f7ca9b244180d3cfb1987cbc9743/lts-3.22/7.10.2/etc"

getBinDir, getLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "use_cloudhaskell_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "use_cloudhaskell_libdir") (\_ -> return libdir)
getDataDir = catchIO (getEnv "use_cloudhaskell_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "use_cloudhaskell_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "use_cloudhaskell_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "/" ++ name)
