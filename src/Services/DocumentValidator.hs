-- | Module for validating markdown and html documents
module Services.DocumentValidator where

import qualified Data.ByteString.Lazy as BSL
import qualified Data.ByteString.Char8 as BS
import Text.Regex.TDFA ((=~))
import Text.Regex.TDFA.Text ()
import Control.Monad (liftM2)
import Control.Monad.Trans.Except (throwE)
import Data.Maybe (fromJust)
import Models.MarkdownDocument (MarkdownDocument(..))
import Models.HtmlDocument (HtmlDocument(..))
import Utils.ErrorHandling (ValidationError(..), throwValidationError)

-- | Validate a markdown document
validateMarkdownDocument :: MarkdownDocument -> Either ValidationError MarkdownDocument
validateMarkdownDocument doc
  | not (isValidTitle (mdTitle doc)) = Left $ ValidationError "Invalid title"
  | not (isValidContent (mdContent doc)) = Left $ ValidationError "Invalid content"
  | otherwise = Right doc
  where
    isValidTitle title = title =~ "^[a-zA-Z0-9\\s]+$" :: Bool
    isValidContent content = content =~ "^[a-zA-Z0-9\\s\\n]+$" :: Bool

-- | Validate an html document
validateHtmlDocument :: HtmlDocument -> Either ValidationError HtmlDocument
validateHtmlDocument doc
  | not (isValidTitle (htmlTitle doc)) = Left $ ValidationError "Invalid title"
  | not (isValidContent (htmlContent doc)) = Left $ ValidationError "Invalid content"
  | otherwise = Right doc
  where
    isValidTitle title = title =~ "^[a-zA-Z0-9\\s]+$" :: Bool
    isValidContent content = content =~ "^[a-zA-Z0-9\\s\\n]+$" :: Bool

-- | Validate a markdown document and return a validated markdown document
validateMarkdown :: MarkdownDocument -> IO MarkdownDocument
validateMarkdown doc = case validateMarkdownDocument doc of
  Left err -> throwValidationError err
  Right validatedDoc -> return validatedDoc

-- | Validate an html document and return a validated html document
validateHtml :: HtmlDocument -> IO HtmlDocument
validateHtml doc = case validateHtmlDocument doc of
  Left err -> throwValidationError err
  Right validatedDoc -> return validatedDoc