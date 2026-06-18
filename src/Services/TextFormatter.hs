module Services.TextFormatter where

import Data.Text (Text)
import qualified Data.Text as T
import Text.Printf (printf)

-- | Formats the given text by wrapping it at the specified width
formatText :: Int -> Text -> Text
formatText width text = T.unlines $ formatText' width text

-- | Formats the given text by wrapping it at the specified width
formatText' :: Int -> Text -> [Text]
formatText' width text = go text
  where
    go :: Text -> [Text]
    go txt
      | T.null txt = []
      | otherwise =
        let (line, rest) = T.splitAt width txt
         in line : go (T.dropWhile (== ' ') rest)

-- | Generates a table of contents for the given markdown text
generateTableOfContents :: Text -> Text
generateTableOfContents text = T.unlines $ generateTableOfContents' text

-- | Generates a table of contents for the given markdown text
generateTableOfContents' :: Text -> [Text]
generateTableOfContents' text = go (T.lines text)
  where
    go :: [Text] -> [Text]
    go [] = []
    go (line : lines)
      | T.isPrefixOf "#" line = line : go lines
      | otherwise = go lines

-- | Formats the given markdown text by wrapping it at the specified width
-- and generating a table of contents
formatMarkdownText :: Int -> Text -> Text
formatMarkdownText width text = T.unlines [formatText width text, generateTableOfContents text]