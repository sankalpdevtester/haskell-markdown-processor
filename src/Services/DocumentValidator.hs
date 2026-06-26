-- | Module for validating Markdown and HTML documents.
module Services.DocumentValidator where

import qualified Data.ByteString.Lazy.Char8 as BL
import qualified Data.Text as T
import Text.Parsec
import Text.Parsec.String

import Models.MarkdownDocument
import Models.HtmlDocument
import Utils.ErrorHandling

-- | Validate a Markdown document.
validateMarkdownDocument :: MarkdownDocument -> Either String MarkdownDocument
validateMarkdownDocument doc = case parse markdownParser "" (BL.unpack $ markdownContent doc) of
  Left err -> Left $ "Failed to parse Markdown: " ++ show err
  Right _ -> Right doc

-- | Validate an HTML document.
validateHtmlDocument :: HtmlDocument -> Either String HtmlDocument
validateHtmlDocument doc = case parse htmlParser "" (BL.unpack $ htmlContent doc) of
  Left err -> Left $ "Failed to parse HTML: " ++ show err
  Right _ -> Right doc

-- | Markdown parser.
markdownParser :: Parsec String () ()
markdownParser = do
  many $ noneOf "\n"
  newline
  many $ noneOf "\n"

-- | HTML parser.
htmlParser :: Parsec String () ()
htmlParser = do
  many $ noneOf "<"
  try (string "<html>") <|> try (string "<body>") <|> try (string "<head>")
  many $ noneOf ">"

-- | Validate a document based on its type.
validateDocument :: T.Text -> BL.ByteString -> Either String BL.ByteString
validateDocument "markdown" content = case validateMarkdownDocument (MarkdownDocument content) of
  Left err -> Left $ T.pack err
  Right _ -> Right content
validateDocument "html" content = case validateHtmlDocument (HtmlDocument content) of
  Left err -> Left $ T.pack err
  Right _ -> Right content
validateDocument _ _ = Left "Unsupported document type"

-- | Validate a document and return a JSON response.
validateDocumentResponse :: T.Text -> BL.ByteString -> Either String BL.ByteString
validateDocumentResponse docType content = case validateDocument docType content of
  Left err -> Left $ BL.pack $ "{\"error\":\"" ++ T.unpack err ++ "\"}"
  Right _ -> Right $ BL.pack "{\"message\":\"Document is valid\"}"