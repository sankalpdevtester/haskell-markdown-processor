{-# LANGUAGE OverloadedStrings #-}

module Controllers.HtmlController where

import Web.Scotty
import qualified Data.Text as T
import qualified Data.Text.Encoding as TE
import qualified Data.ByteString as B
import qualified Data.ByteString.Lazy as BL
import Data.Aeson (decode, encode)
import qualified Data.Aeson as J
import qualified Models.MarkdownDocument as MD
import qualified Services.MarkdownConverter as MC
import qualified Utils.ErrorHandling as EH

htmlConversionRoute :: ScottyM ()
htmlConversionRoute = post "/convert/html" $ do
  markdownText <- body
  let markdownDoc = MD.MarkdownDocument markdownText
  html <- liftAndCatchIO $ MC.convertMarkdownToHtml markdownDoc
  json $ J.object ["html" J..= html]

htmlConversionWithTemplateRoute :: ScottyM ()
htmlConversionWithTemplateRoute = post "/convert/html/template" $ do
  markdownText <- body
  template <- param "template"
  let markdownDoc = MD.MarkdownDocument markdownText
  html <- liftAndCatchIO $ MC.convertMarkdownToHtmlWithTemplate markdownDoc template
  json $ J.object ["html" J..= html]

htmlConversionErrorHandler :: ScottyM ()
htmlConversionErrorHandler = rescue (\(e :: EH.Error) -> do
  let errorMessage = EH.handleError e
  status 500
  json $ J.object ["error" J..= errorMessage])

htmlController :: ScottyM ()
htmlController = do
  htmlConversionRoute
  htmlConversionWithTemplateRoute
  htmlConversionErrorHandler