module Controllers.TableOfContentsController where

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
import Services.MarkdownConverter
import Utils.CacheManager

data TableOfContents = TableOfContents
  { tocTitle :: String
  , tocLevel :: Int
  , tocLink :: String
  } deriving (Show)

generateTableOfContents :: MarkdownDocument -> [TableOfContents]
generateTableOfContents markdownDoc = query markdownDoc
  where
    query :: MarkdownDocument -> [TableOfContents]
    query (MarkdownDocument markdown) = walk markdown $ \case
      Header level title -> [TableOfContents (T.unpack title) level (T.unpack title)]
      _ -> []

tableOfContentsRoute :: ScottyM ()
tableOfContentsRoute = get "/table-of-contents" $ do
  markdownDoc <- param "markdownDoc"
  let toc = generateTableOfContents markdownDoc
  json toc

tableOfContentsCacheRoute :: ScottyM ()
tableOfContentsCacheRoute = get "/table-of-contents/cache" $ do
  markdownDoc <- param "markdownDoc"
  cacheManager <- liftIO $ getCacheManager
  let toc = generateTableOfContents markdownDoc
  liftIO $ cacheTableOfContents cacheManager markdownDoc toc
  json toc

cacheTableOfContents :: CacheManager -> MarkdownDocument -> [TableOfContents] -> IO ()
cacheTableOfContents cacheManager markdownDoc toc = do
  let cacheKey = getCacheKey markdownDoc
  putCache cacheManager cacheKey toc