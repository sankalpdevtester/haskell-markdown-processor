module Src.Utils.PdfUtils where

import qualified Data.ByteString.Lazy as BSL
import qualified Data.Text as T
import qualified Text.Pandoc as Pandoc
import qualified Text.Pandoc.Options as PandocOptions
import Src.Models.HtmlDocument (HtmlDocument (..))
import Src.Models.MarkdownDocument (MarkdownDocument (..))

generatePdf :: MarkdownDocument -> IO HtmlDocument
generatePdf markdownDoc = do
  let markdownText = markdownDocText markdownDoc
  let template = loadTemplate "pdf-template.html"
  let html = Pandoc.runPure $ Pandoc.pandoc (PandocOptions.defaultOptions { PandocOptions.writerTemplate = template }) markdownText
  let htmlText = TE.decodeUtf8 $ Pandoc.writeHtml5String PandocOptions.defaultOptions html
  return $ HtmlDocument htmlText

pdfToBytes :: HtmlDocument -> IO BSL.ByteString
pdfToBytes htmlDoc = do
  let htmlText = htmlDocText htmlDoc
  let pdfBytes = BS.pack $ T.unpack htmlText
  return $ BSL.fromStrict pdfBytes