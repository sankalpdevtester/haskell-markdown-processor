-- | This module provides a service for validating Markdown documents.
module Services.DocumentValidator where

import qualified Data.ByteString.Lazy.Char8 as BSL
import qualified Data.Text as T
import qualified Data.Text.Encoding as TE
import Text.Parsec
import Text.Parsec.String

import Models.MarkdownDocument (MarkdownDocument(..))
import Utils.ErrorHandling (AppError(..), throwAppError)

-- | Validate a Markdown document.
validateDocument :: MarkdownDocument -> Either AppError MarkdownDocument
validateDocument doc = case parse markdownParser "" (mdContent doc) of
  Left err -> Left $ AppError $ T.pack $ show err
  Right _ -> Right doc

-- | Markdown parser.
markdownParser :: Parser ()
markdownParser = do
  many (try headerParser <|> try paragraphParser <|> try linkParser)
  eof

-- | Header parser.
headerParser :: Parser ()
headerParser = do
  char '#'
  many (noneOf "\n")
  newline
  return ()

-- | Paragraph parser.
paragraphParser :: Parser ()
paragraphParser = do
  many (noneOf "\n")
  newline
  return ()

-- | Link parser.
linkParser :: Parser ()
linkParser = do
  char '['
  many (noneOf "]")
  char ']'
  char '('
  many (noneOf ")")
  char ')'
  return ()

-- | Validate a Markdown document and return the validated document.
validateAndReturnDocument :: MarkdownDocument -> IO MarkdownDocument
validateAndReturnDocument doc = case validateDocument doc of
  Left err -> throwAppError err
  Right validatedDoc -> return validatedDoc