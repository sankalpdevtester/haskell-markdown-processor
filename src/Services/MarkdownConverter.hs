-- | MarkdownConverter service for document conversion
module Services.MarkdownConverter where

import Models.MarkdownDocument
import Text.Pandoc
import Text.Pandoc.Error
import qualified Data.Text as T

-- | MarkdownConverter data type
data MarkdownConverter = MarkdownConverter

-- | Convert MarkdownDocument to HTML
convertToHtml :: MarkdownConverter -> MarkdownDocument -> Either PandocError Text
convertToHtml _ markdown = Right $ markdownToHtml markdown

-- | Convert MarkdownDocument to PDF
convertToPdf :: MarkdownConverter -> MarkdownDocument -> Either PandocError Text
convertToPdf _ markdown = Right $ markdownToPdf markdown

-- | Generate table of contents for MarkdownDocument
generateTableOfContents :: MarkdownConverter -> MarkdownDocument -> Either PandocError Text
generateTableOfContents _ markdown = Right $ generateToc markdown

-- | Create a new MarkdownConverter instance
newMarkdownConverter :: MarkdownConverter
newMarkdownConverter = MarkdownConverter