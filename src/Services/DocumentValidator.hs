-- | Document validation service for Markdown and HTML documents
module Services.DocumentValidator where

import qualified Data.ByteString.Lazy as BSL
import qualified Data.ByteString.Char8 as BS
import Data.Maybe (fromMaybe)
import Text.Regex (matchRegex, mkRegex)
import Models.MarkdownDocument (MarkdownDocument(..))
import Models.HtmlDocument (HtmlDocument(..))
import Utils.ErrorHandling (AppError(..), throwAppError)

-- | Validate a Markdown document
validateMarkdownDocument :: MarkdownDocument -> Either AppError MarkdownDocument
validateMarkdownDocument doc
  | null (mdContent doc) = Left $ AppError "Markdown content is empty"
  | not (isValidMarkdown doc) = Left $ AppError "Invalid Markdown syntax"
  | otherwise = Right doc

-- | Validate an HTML document
validateHtmlDocument :: HtmlDocument -> Either AppError HtmlDocument
validateHtmlDocument doc
  | null (htmlContent doc) = Left $ AppError "HTML content is empty"
  | not (isValidHtml doc) = Left $ AppError "Invalid HTML syntax"
  | otherwise = Right doc

-- | Check if a Markdown document has valid syntax
isValidMarkdown :: MarkdownDocument -> Bool
isValidMarkdown doc = isJust $ matchRegex (mkRegex "^#.*$") (BSL.toStrict $ mdContent doc)

-- | Check if an HTML document has valid syntax
isValidHtml :: HtmlDocument -> Bool
isValidHtml doc = isJust $ matchRegex (mkRegex "^<html>.*</html>$") (BSL.toStrict $ htmlContent doc)

-- | Validate a document based on its type
validateDocument :: String -> BSL.ByteString -> Either AppError (Either MarkdownDocument HtmlDocument)
validateDocument "markdown" content = do
  doc <- parseMarkdownDocument content
  pure $ Left doc
  where
    parseMarkdownDocument :: BSL.ByteString -> Either AppError MarkdownDocument
    parseMarkdownDocument content = Right $ MarkdownDocument content

validateDocument "html" content = do
  doc <- parseHtmlDocument content
  pure $ Right doc
  where
    parseHtmlDocument :: BSL.ByteString -> Either AppError HtmlDocument
    parseHtmlDocument content = Right $ HtmlDocument content

validateDocument _ _ = Left $ AppError "Unsupported document type"

-- | Validate a document and return the validated document
validateAndReturnDocument :: String -> BSL.ByteString -> Either AppError (Either MarkdownDocument HtmlDocument)
validateAndReturnDocument docType content = do
  doc <- validateDocument docType content
  case doc of
    Left markdownDoc -> do
      validatedDoc <- validateMarkdownDocument markdownDoc
      pure $ Left validatedDoc
    Right htmlDoc -> do
      validatedDoc <- validateHtmlDocument htmlDoc
      pure $ Right validatedDoc