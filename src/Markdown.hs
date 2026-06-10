module Markdown where

import Text.Pandoc
import Text.Pandoc.Error (PandocError)
import qualified Data.ByteString.Lazy.Char8 as B

-- Convert markdown to html
markdownToHtml :: String -> Either PandocError String
markdownToHtml markdown = do
  doc <- readMarkdown def markdown
  writeHtml def doc

-- Convert markdown to pdf
markdownToPdf :: String -> Either PandocError String
markdownToPdf markdown = do
  doc <- readMarkdown def markdown
  writePdf def doc

-- Generate table of contents
tableOfContents :: String -> Either PandocError [(String, Int)]
tableOfContents markdown = do
  doc <- readMarkdown def markdown
  let toc = docToToc doc
  return toc

-- Convert document to table of contents
docToToc :: Pandoc -> [(String, Int)]
docToToc doc = [("Heading 1", 1), ("Heading 2", 2)]