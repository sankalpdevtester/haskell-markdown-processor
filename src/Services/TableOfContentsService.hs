module Services.TableOfContentsService where

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
import Utils.CacheManager

data TableOfContentsService = TableOfContentsService
  { generateTableOfContents :: MarkdownDocument -> [TableOfContents]
  , cacheTableOfContents :: CacheManager -> MarkdownDocument -> [TableOfContents] -> IO ()
  } deriving (Show)

tableOfContentsService :: TableOfContentsService
tableOfContentsService = TableOfContentsService
  { generateTableOfContents = generateTableOfContents
  , cacheTableOfContents = cacheTableOfContents
  }

generateTableOfContents :: MarkdownDocument -> [TableOfContents]
generateTableOfContents markdownDoc = query markdownDoc
  where
    query :: MarkdownDocument -> [TableOfContents]
    query (MarkdownDocument markdown) = walk markdown $ \case
      Header level title -> [TableOfContents (T.unpack title) level (T.unpack title)]
      _ -> []

cacheTableOfContents :: CacheManager -> MarkdownDocument -> [TableOfContents] -> IO ()
cacheTableOfContents cacheManager markdownDoc toc = do
  let cacheKey = getCacheKey markdownDoc
  putCache cacheManager cacheKey toc

getCacheKey :: MarkdownDocument -> String
getCacheKey markdownDoc = show markdownDoc