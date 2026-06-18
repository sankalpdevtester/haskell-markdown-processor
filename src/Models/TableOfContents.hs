module Models.TableOfContents where

import qualified Data.Text as T
import qualified Data.Text.IO as TIO
import Text.Pandoc
import Text.Pandoc.Walk
import qualified Data.Map as M
import Data.List (sortOn)
import Data.Ord (comparing)
import qualified Data.ByteString.Lazy as B
import qualified Data.ByteString.Char8 as C
import Network.HTTP.Types
import Web.Scotty

data TableOfContents = TableOfContents
  { tocTitle :: String
  , tocLevel :: Int
  , tocLink :: String
  } deriving (Show)

instance ToJSON TableOfContents where
  toJSON (TableOfContents title level link) =
    object ["title" .= title, "level" .= level, "link" .= link]

instance FromJSON TableOfContents where
  parseJSON (Object v) = TableOfContents
    <$> v .: "title"
    <*> v .: "level"
    <*> v .: "link"
  parseJSON _ = fail "Expected Object"

instance ToJSONKey TableOfContents where
  toJSONKey = toJSONKeyText (T.pack . show)

instance FromJSONKey TableOfContents where
  fromJSONKey = fromJSONKeyText (read . T.unpack)