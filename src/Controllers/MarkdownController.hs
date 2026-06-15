-- | MarkdownController for handling Markdown requests
module Controllers.MarkdownController where

import Web.Scotty
import Models.MarkdownDocument
import Services.MarkdownConverter
import qualified Data.Text as T

-- | MarkdownController data type
data MarkdownController = MarkdownController

-- | Handle Markdown to HTML conversion request
handleMarkdownToHtml :: MarkdownController -> Text -> ActionM ()
handleMarkdownToHtml _ markdown = do
  case parseMarkdown markdown of
    Right doc -> json $ markdownToHtml doc
    Left err -> json $ T.pack $ show err

-- | Handle Markdown to PDF conversion request
handleMarkdownToPdf :: MarkdownController -> Text -> ActionM ()
handleMarkdownToPdf _ markdown = do
  case parseMarkdown markdown of
    Right doc -> json $ markdownToPdf doc
    Left err -> json $ T.pack $ show err

-- | Handle table of contents generation request
handleGenerateToc :: MarkdownController -> Text -> ActionM ()
handleGenerateToc _ markdown = do
  case parseMarkdown markdown of
    Right doc -> json $ generateToc doc
    Left err -> json $ T.pack $ show err

-- | Create a new MarkdownController instance
newMarkdownController :: MarkdownController
newMarkdownController = MarkdownController

-- | Mount MarkdownController routes
mountRoutes :: MarkdownController -> ScottyM ()
mountRoutes controller = do
  post "/markdown-to-html" $ handleMarkdownToHtml controller =<< param "markdown"
  post "/markdown-to-pdf" $ handleMarkdownToPdf controller =<< param "markdown"
  post "/generate-toc" $ handleGenerateToc controller =<< param "markdown"