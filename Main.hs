{-# LANGUAGE OverloadedStrings #-}

import Turtle                      
import Prelude hiding (FilePath)
                                   
main :: IO ()
main = do
    file <- options "Sets the wallpaper, color scheme, and lock screen background using FILE" parser
    setWallpaper file

setWallpaper :: FilePath -> IO ()
setWallpaper file = do
    case (toText file) of
        Right path -> do
            proc wal ["-i", path] empty .||. die "Failed to set wallpaper. Aborting."
            proc betterlockscreen ["-u", path] empty .||. die "Failed to set lock screen image."
        Left invalidPath ->
            die $ format ("The path '" %s% "' is invalid! Aborting.") invalidPath
    return ()

    where
        wal = _ER_PATH_WAL_
        betterlockscreen = _ER_PATH_BETTERLOCKSCREEN_

parser :: Parser FilePath
parser =
    argPath "file"  "The image file to use"
