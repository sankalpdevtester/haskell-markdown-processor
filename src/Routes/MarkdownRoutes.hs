-- | Markdown routes
module Routes.MarkdownRoutes where

import Web.Scotty
import Controllers.MarkdownController
import Utils.ErrorHandling

-- | Mount Markdown routes
mountRoutes :: ScottyM ()
mountRoutes = do
  let controller = newMarkdownController
  mountRoutes controller
  -- Handle any exceptions in the Markdown routes
  catchExceptions $ do
    -- Mount Markdown routes
    post "/markdown-to-html" $ handleMarkdownToHtml controller =<< param "markdown"
    post "/markdown-to-pdf" $ handleMarkdownToPdf controller =<< param "markdown"
    post "/generate-toc" $ handleGenerateToc controller =<< param "markdown"
    -- Handle any Pandoc errors in the Markdown routes
    rescue (handlePandocError)