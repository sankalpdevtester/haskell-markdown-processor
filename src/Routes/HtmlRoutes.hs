{-# LANGUAGE OverloadedStrings #-}

module Routes.HtmlRoutes where

import Web.Scotty
import qualified Controllers.HtmlController as HC

htmlRoutes :: ScottyM ()
htmlRoutes = do
  HC.htmlController

htmlRoute :: ScottyM ()
htmlRoute = get "/html" $ do
  html <- liftAndCatchIO $ return "HTML Conversion Route"
  json $ J.object ["html" J..= html]