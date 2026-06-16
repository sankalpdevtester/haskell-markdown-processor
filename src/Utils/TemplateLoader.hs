{-# LANGUAGE OverloadedStrings #-}

module Utils.TemplateLoader where

import qualified Data.Text as T
import qualified Data.Text.IO as TIO
import System.IO (openFile, IOMode (ReadMode), hClose)
import qualified System.FilePath as FP

loadTemplate :: T.Text -> IO T.Text
loadTemplate templateName = do
  let templatePath = FP.</> "templates" $ T.unpack templateName
  handle <- openFile templatePath ReadMode
  template <- TIO.hGetContents handle
  hClose handle
  return template

loadDefaultTemplate :: IO T.Text
loadDefaultTemplate = loadTemplate "default.html"

loadTemplateWithErrorHandling :: T.Text -> IO (Either T.Text T.Text)
loadTemplateWithErrorHandling templateName = do
  result <- try $ loadTemplate templateName
  case result of
    Right template -> return $ Right template
    Left err -> return $ Left $ T.pack $ show err