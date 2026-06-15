-- | MarkdownDocument model for parsing and conversion
module Models.MarkdownDocument where

import Data.Text (Text)
import qualified Data.Text as T
import Text.Pandoc
import Text.Pandoc.Error

-- | MarkdownDocument data type
data MarkdownDocument = MarkdownDocument
  { mdTitle :: Text
  , mdContent :: Text
  } deriving (Show, Eq)

-- | Parse Markdown text into a MarkdownDocument
parseMarkdown :: Text -> Either PandocError MarkdownDocument
parseMarkdown markdown = do
  doc <- readMarkdown def markdown
  let title = docTitle doc
      content = writeHtml5String def doc
  return $ MarkdownDocument title content

-- | Convert MarkdownDocument to HTML
markdownToHtml :: MarkdownDocument -> Text
markdownToHtml (MarkdownDocument _ content) = content

-- | Convert MarkdownDocument to PDF
markdownToPdf :: MarkdownDocument -> Text
markdownToPdf (MarkdownDocument title _) = title <> ".pdf"

-- | Generate table of contents for MarkdownDocument
generateToc :: MarkdownDocument -> Text
generateToc (MarkdownDocument _ content) = T.pack $ show $ tableOfContents def content