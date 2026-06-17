module Src.Models.PdfDocument where

import qualified Data.ByteString.Lazy as BSL
import qualified Data.Text as T

data PdfDocument = PdfDocument
  { pdfDocumentBytes :: BSL.ByteString
  , pdfDocumentText :: T.Text
  } deriving (Show)

pdfDocumentFromHtml :: HtmlDocument -> PdfDocument
pdfDocumentFromHtml htmlDoc = PdfDocument
  { pdfDocumentBytes = BSL.fromStrict $ BS.pack $ T.unpack $ htmlDocText htmlDoc
  , pdfDocumentText = htmlDocText htmlDoc
  }