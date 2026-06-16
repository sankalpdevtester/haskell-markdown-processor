{-# LANGUAGE OverloadedStrings #-}

module Services.HtmlConverter where

import qualified Data.Text as T
import qualified Data.Text.Encoding as TE
import qualified Data.ByteString as B
import qualified Data.ByteString.Lazy as BL
import Text.Pandoc
import Text.Pandoc.Error
import qualified Models.MarkdownDocument as MD

convertMarkdownToHtml :: MD.MarkdownDocument -> IO T.Text
convertMarkdownToHtml markdownDoc = do
  let markdownText = MD.markdownText markdownDoc
  let reader = readMarkdown def { readerExtensions = pandocExtensions }
  let writer = writeHtml5String def
  result <- runIO $ runPandoc $ reader markdownText
  case result of
    Right doc -> return $ writer doc
    Left err -> throwIO $ PandocError err

convertMarkdownToHtmlWithTemplate :: MD.MarkdownDocument -> T.Text -> IO T.Text
convertMarkdownToHtmlWithTemplate markdownDoc template = do
  let markdownText = MD.markdownText markdownDoc
  let reader = readMarkdown def { readerExtensions = pandocExtensions }
  let writer = writeHtml5String def
  result <- runIO $ runPandoc $ reader markdownText
  case result of
    Right doc -> do
      let html = writer doc
      return $ T.concat [template, html]
    Left err -> throwIO $ PandocError err