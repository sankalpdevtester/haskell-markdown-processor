module Utils.TextUtils where

import Data.Text (Text)
import qualified Data.Text as T

-- | Trims the given text
trim :: Text -> Text
trim text = T.dropWhile (== ' ') $ T.reverse $ T.dropWhile (== ' ') $ T.reverse text

-- | Wraps the given text at the specified width
wrap :: Int -> Text -> Text
wrap width text = T.unlines $ wrap' width text

-- | Wraps the given text at the specified width
wrap' :: Int -> Text -> [Text]
wrap' width text = go text
  where
    go :: Text -> [Text]
    go txt
      | T.null txt = []
      | otherwise =
        let (line, rest) = T.splitAt width txt
         in line : go (T.dropWhile (== ' ') rest)

-- | Generates a table of contents for the given text
generateTableOfContents :: Text -> Text
generateTableOfContents text = T.unlines $ generateTableOfContents' text

-- | Generates a table of contents for the given text
generateTableOfContents' :: Text -> [Text]
generateTableOfContents' text = go (T.lines text)
  where
    go :: [Text] -> [Text]
    go [] = []
    go (line : lines)
      | T.isPrefixOf "#" line = line : go lines
      | otherwise = go lines