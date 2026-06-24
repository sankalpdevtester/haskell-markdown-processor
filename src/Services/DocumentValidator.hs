-- | Module for validating Markdown documents
module Services.DocumentValidator where

import Control.Monad (liftM2)
import Data.Maybe (isJust, fromJust)
import Text.Parsec (ParseError)
import Text.Parsec.Error (errorPos)

import qualified Models.MarkdownDocument as MD
import qualified Utils.ErrorHandling as EH
import qualified Services.MarkdownConverter as MC

-- | Validate a Markdown document
validateDocument :: MD.MarkdownDocument -> Either EH.AppError MD.MarkdownDocument
validateDocument doc = do
  -- Check if the document has a title
  when (null $ MD.title doc) $ Left EH.MissingTitleError

  -- Check if the document has content
  when (null $ MD.content doc) $ Left EH.EmptyDocumentError

  -- Try to parse the Markdown content
  case MC.parseMarkdown (MD.content doc) of
    Left err -> Left $ EH.ParseError $ show err
    Right _ -> Right doc

-- | Validate a list of Markdown documents
validateDocuments :: [MD.MarkdownDocument] -> Either EH.AppError [MD.MarkdownDocument]
validateDocuments docs = mapM validateDocument docs

-- | Check if a document has a valid title
hasValidTitle :: MD.MarkdownDocument -> Bool
hasValidTitle doc = not $ null $ MD.title doc

-- | Check if a document has valid content
hasValidContent :: MD.MarkdownDocument -> Bool
hasValidContent doc = not $ null $ MD.content doc

-- | Get the validation errors for a document
getValidationErrors :: MD.MarkdownDocument -> [EH.AppError]
getValidationErrors doc
  | null (MD.title doc) = [EH.MissingTitleError]
  | null (MD.content doc) = [EH.EmptyDocumentError]
  | otherwise = []

-- | Example usage:
-- validateDocument (MD.MarkdownDocument "Example" "This is an example document.")
-- validateDocuments [MD.MarkdownDocument "Example 1" "This is an example document.", MD.MarkdownDocument "" "This is another example document."]