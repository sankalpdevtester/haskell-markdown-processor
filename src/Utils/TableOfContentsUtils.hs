module Utils.TableOfContentsUtils where

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
import Models.MarkdownDocument
import Controllers.TableOfContentsController
import Services.TableOfContentsService

data TableOfContentsUtils = TableOfContentsUtils
  { getTableOfContents :: MarkdownDocument -> [TableOfContents]
  , getTableOfContentsFromCache :: CacheManager -> MarkdownDocument -> IO [TableOfContents]
  } deriving (Show)

tableOfContentsUtils :: TableOfContentsUtils
tableOfContentsUtils = TableOfContentsUtils
  { getTableOfContents = getTableOfContents
  , getTableOfContentsFromCache = getTableOfContentsFromCache
  }

getTableOfContents :: MarkdownDocument -> [TableOfContents]
getTableOfContents markdownDoc = query markdownDoc
  where
    query :: MarkdownDocument -> [TableOfContents]
    query (MarkdownDocument markdown) = walk markdown $ \case
      Header level title -> [TableOfContents (T.unpack title) level (T.unpack title)]
      _ -> []

getTableOfContentsFromCache :: CacheManager -> MarkdownDocument -> IO [TableOfContents]
getTableOfContentsFromCache cacheManager markdownDoc = do
  let cacheKey = getCacheKey markdownDoc
  getCache cacheManager cacheKey

getCacheKey :: MarkdownDocument -> String
getCacheKey markdownDoc = show markdownDoc