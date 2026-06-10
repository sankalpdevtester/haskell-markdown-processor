{-# LANGUAGE OverloadedStrings #-}
import Web.Scotty
import Text.Pandoc
import System.Directory
import System.FilePath
import System.Process
import Control.Monad

main :: IO ()
main = scotty 3000 $ do
  get "/markdown-to-html" $ do
    markdown <- param "markdown"
    let html = writeHtml (readMarkdown markdown)
    html $ html

  get "/markdown-to-pdf" $ do
    markdown <- param "markdown"
    let pdf = writePdf (readMarkdown markdown)
    pdf $ pdf

  get "/text-formatting" $ do
    text <- param "text"
    let formattedText = formatText text
    text $ formattedText

  get "/table-of-contents" $ do
    markdown <- param "markdown"
    let toc = generateToc (readMarkdown markdown)
    text $ toc

  get "/error-handling" $ do
    error "Error handling test"

readMarkdown :: String -> Pandoc
readMarkdown markdown = readMarkdown' markdown

writeHtml :: Pandoc -> String
writeHtml pandoc = writeHtml' pandoc

writePdf :: Pandoc -> String
writePdf pandoc = writePdf' pandoc

formatText :: String -> String
formatText text = formatText' text

generateToc :: Pandoc -> String
generateToc pandoc = generateToc' pandoc

readMarkdown' :: String -> Pandoc
readMarkdown' markdown = either (error . show) id $ runParser parseMarkdown "" markdown

writeHtml' :: Pandoc -> String
writeHtml' pandoc = writeHtmlString pandoc

writePdf' :: Pandoc -> String
writePdf' pandoc = writePdfString pandoc

formatText' :: String -> String
formatText' text = text

generateToc' :: Pandoc -> String
generateToc' pandoc = ""