{-# LANGUAGE OverloadedStrings #-}
import qualified    Data.Text       as T
import              Data.Text       (Text)
import              Text.Pandoc
import              Text.Pandoc.Definition
import              Text.Pandoc.JSON


data Which = Color | Highlight


beforeColor :: Text -> [Inline]
beforeColor color     = [RawInline (Format "html")    ("<span style=\"color:"<>color<>";\">")
                        ,RawInline (Format "latex")   ("{\\color{"<>color<>"}")
                        ,RawInline (Format "context") ("\\startcolor["<>color<>"]")]


beforeHighlight :: Text -> [Inline]
beforeHighlight color = [RawInline (Format "html")  ("<span style=\"background-color:"<>color<>";\">")
                        ,RawInline (Format "latex") ("\\sethlcolor{"<>color<>"} \\hl{")]

afterColor :: [Inline]
afterColor = [RawInline (Format "html")    "</span>"
             ,RawInline (Format "latex")   "}"
             ,RawInline (Format "context") "\\stopcolor"]

afterHighlight :: [Inline]
afterHighlight = [RawInline (Format "html")  "</span>"
                 ,RawInline (Format "latex") "} \\sethlcolor{}"]


coloredText :: (Which, Text) -> [Inline] -> [Inline]
coloredText (Color,     color) inlines = (beforeColor color)     <> inlines <> afterColor
coloredText (Highlight, color) inlines = (beforeHighlight color) <> inlines <> afterHighlight


findColor :: [(Text, Text)] -> Maybe (Which, Text)
findColor [] = Nothing
findColor (("color", color)     : rest) = Just (Color, color)
findColor (("highlight", color) : rest) = Just (Highlight, color)
findColor (_:rest) = findColor rest


latexHighlightHtml :: Inline -> Inline
latexHighlightHtml span@(Span attrs@(_, _, pairs) inlines)
  = case findColor pairs of
         Just pair -> Span attrs $ coloredText pair inlines
         Nothing   -> span

latexHighlightHtml x = x


main :: IO ()
main = toJSONFilter latexHighlightHtml
