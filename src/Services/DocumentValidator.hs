-- | Module for validating Markdown documents
module Services.DocumentValidator where

import Control.Monad (liftM2)
import Data.List (find)
import Data.Maybe (isJust)
import Models.MarkdownDocument (MarkdownDocument(..))
import Models.HtmlDocument (HtmlDocument(..))
import Utils.ErrorHandling (ValidationError(..), throwValidationError)
import Text.Parsec (ParseError, parse)

-- | Validate a Markdown document
validateMarkdownDocument :: MarkdownDocument -> Either ValidationError MarkdownDocument
validateMarkdownDocument doc
  | null (mdTitle doc) = Left $ ValidationError "Title cannot be empty"
  | null (mdContent doc) = Left $ ValidationError "Content cannot be empty"
  | otherwise = Right doc

-- | Validate an HTML document
validateHtmlDocument :: HtmlDocument -> Either ValidationError HtmlDocument
validateHtmlDocument doc
  | null (htmlTitle doc) = Left $ ValidationError "Title cannot be empty"
  | null (htmlContent doc) = Left $ ValidationError "Content cannot be empty"
  | otherwise = Right doc

-- | Validate a Markdown document and convert it to HTML
validateAndConvertMarkdown :: MarkdownDocument -> Either ValidationError HtmlDocument
validateAndConvertMarkdown doc = do
  validatedDoc <- validateMarkdownDocument doc
  let htmlDoc = convertMarkdownToHtml validatedDoc
  validateHtmlDocument htmlDoc

-- | Convert a Markdown document to HTML
convertMarkdownToHtml :: MarkdownDocument -> HtmlDocument
convertMarkdownToHtml doc = HtmlDocument
  { htmlTitle = mdTitle doc
  , htmlContent = mdContent doc
  }

-- | Validate a list of Markdown documents
validateMarkdownDocuments :: [MarkdownDocument] -> Either ValidationError [MarkdownDocument]
validateMarkdownDocuments docs = mapM validateMarkdownDocument docs

-- | Example usage
exampleUsage :: IO ()
exampleUsage = do
  let doc = MarkdownDocument "Example Title" "Example Content"
  case validateMarkdownDocument doc of
    Left err -> print err
    Right validatedDoc -> print validatedDoc