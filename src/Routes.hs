module Routes where

import Web.Scotty
import Config (loadConfig)
import qualified Data.ByteString.Lazy.Char8 as B

-- Define routes for markdown processing
routes :: ScottyM ()
routes = do
  get "/markdown-to-html" $ do
    markdown <- param "markdown"
    config <- liftIO loadConfig
    let html = markdownToHtml markdown
    html $ B.pack html

  get "/markdown-to-pdf" $ do
    markdown <- param "markdown"
    config <- liftIO loadConfig
    let pdf = markdownToPdf markdown
    file $ pdf

  get "/table-of-contents" $ do
    markdown <- param "markdown"
    config <- liftIO loadConfig
    let toc = tableOfContents markdown
    json toc

-- Convert markdown to html
markdownToHtml :: String -> String
markdownToHtml markdown = markdown ++ ".html"

-- Convert markdown to pdf
markdownToPdf :: String -> String
markdownToPdf markdown = markdown ++ ".pdf"

-- Generate table of contents
tableOfContents :: String -> [(String, Int)]
tableOfContents markdown = [("Heading 1", 1), ("Heading 2", 2)]