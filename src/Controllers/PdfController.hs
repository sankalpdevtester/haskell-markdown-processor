module Src.Controllers.PdfController where

import qualified Data.ByteString.Lazy as BSL
import qualified Data.Text as T
import qualified Web.Scotty as Scotty
import Src.Models.HtmlDocument (HtmlDocument (..))
import Src.Models.MarkdownDocument (MarkdownDocument (..))
import Src.Services.PdfConverter (pdfConverterService)
import Src.Utils.ErrorHandling (handleError)
import Src.Utils.TemplateLoader (loadTemplate)

pdfController :: Scotty.ScottyM ()
pdfController = do
  Scotty.post "/pdf" $ do
    markdownText <- Scotty.body
    let markdownDoc = MarkdownDocument markdownText
    pdfBytes <- liftIO $ pdfConverterService markdownDoc
    Scotty.header "Content-Type" "application/pdf"
    Scotty.raw pdfBytes

handlePdfControllerError :: Scotty.ScottyError -> IO ()
handlePdfControllerError e = handleError $ "Error handling PDF request: " ++ show e