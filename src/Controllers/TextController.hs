module Controllers.TextController where

import Web.Scotty (ScottyM, get, json, param)
import qualified Web.Scotty as Scotty
import Services.TextFormatter (formatMarkdownText)
import Models.MarkdownDocument (MarkdownDocument (..))
import Data.Text (Text)
import qualified Data.Text as T

-- | Handles GET requests to the /text endpoint
getText :: ScottyM ()
getText = get "/text" $ do
  text <- param "text"
  width <- param "width"
  let formattedText = formatMarkdownText (read width) text
  json formattedText

-- | Handles GET requests to the /table-of-contents endpoint
getTableOfContents :: ScottyM ()
getTableOfContents = get "/table-of-contents" $ do
  text <- param "text"
  let tableOfContents = Services.TextFormatter.generateTableOfContents text
  json tableOfContents

-- | Initializes the text controller
initTextController :: ScottyM ()
initTextController = do
  getText
  getTableOfContents