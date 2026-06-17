module Src.Services.PdfConverter where

import qualified Data.ByteString.Lazy as BSL
import qualified Data.ByteString.Char8 as BS
import qualified Data.Text as T
import qualified Data.Text.Encoding as TE
import qualified Text.Pandoc as Pandoc
import qualified Text.Pandoc.Options as PandocOptions
import Src.Models.HtmlDocument (HtmlDocument (..))
import Src.Models.MarkdownDocument (MarkdownDocument (..))
import Src.Utils.ErrorHandling (handleError)
import Src.Utils.TemplateLoader (loadTemplate)

pdfConverter :: MarkdownDocument -> IO HtmlDocument
pdfConverter markdownDoc = do
  let markdownText = markdownDocText markdownDoc
  let template = loadTemplate "pdf-template.html"
  let html = Pandoc.runPure $ Pandoc.pandoc (PandocOptions.defaultOptions { PandocOptions.writerTemplate = template }) markdownText
  let htmlText = TE.decodeUtf8 $ Pandoc.writeHtml5String PandocOptions.defaultOptions html
  return $ HtmlDocument htmlText

pdfConverterService :: MarkdownDocument -> IO BSL.ByteString
pdfConverterService markdownDoc = do
  htmlDoc <- pdfConverter markdownDoc
  let htmlText = htmlDocText htmlDoc
  let pdfBytes = BS.pack $ T.unpack htmlText
  return $ BSL.fromStrict pdfBytes

handlePdfConversionError :: IOException -> IO ()
handlePdfConversionError e = handleError $ "Error converting Markdown to PDF: " ++ show e