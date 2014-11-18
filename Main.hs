import System.Environment (getArgs)
import System.Directory (doesFileExist, getModificationTime,
                            renameFile)
import Control.Monad (filterM)
import System.Locale (defaultTimeLocale)
import Data.Time.Format (formatTime)
import System.FilePath.Posix (splitFileName)

main :: IO ()
main = do
    filepaths <- getArgs
    onlyfiles <- getOnlyFiles filepaths
    mapM_ renameWithModTime onlyfiles

--Desugared Implementation
{-anomain :: IO ()-}
{-anomain = getArgs-}
   {->>= (\filepaths -> getOnlyFiles filepaths)-}
   {->>= mapM_ renameWithModTime-}

dateFormat :: String
dateFormat = "%Y_%m_%d"

getOnlyFiles :: [FilePath] -> IO [FilePath]
getOnlyFiles = filterM doesFileExist

renameWithModTime :: FilePath -> IO ()
renameWithModTime f = do
    modtime <- getModificationTime f
    let timeformat = formatTime defaultTimeLocale dateFormat modtime
        newfilename = timeformat ++ "_" ++ (snd $ splitFileName f)
    renameFile f newfilename
