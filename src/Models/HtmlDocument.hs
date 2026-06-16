{-# LANGUAGE OverloadedStrings #-}

module Models.HtmlDocument where

import qualified Data.Text as T
import qualified Data.Aeson as J

data HtmlDocument = HtmlDocument
  { htmlText :: T.Text
  } deriving (Show)

instance J.ToJSON HtmlDocument where
  toJSON (HtmlDocument htmlText) = J.object ["html" J..= htmlText]

instance J.FromJSON HtmlDocument where
  parseJSON (J.Object v) = do
    htmlText <- v J..: "html"
    return $ HtmlDocument htmlText
  parseJSON _ = fail "Invalid HTML document"