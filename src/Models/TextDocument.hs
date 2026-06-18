module Models.TextDocument where

import Data.Text (Text)
import qualified Data.Text as T

-- | Represents a text document
data TextDocument = TextDocument
  { text :: Text
  , width :: Int
  } deriving (Show)

-- | Creates a new text document
newTextDocument :: Text -> Int -> TextDocument
newTextDocument text width = TextDocument text width

-- | Gets the text from a text document
getText :: TextDocument -> Text
getText (TextDocument text _) = text

-- | Gets the width from a text document
getWidth :: TextDocument -> Int
getWidth (TextDocument _ width) = width