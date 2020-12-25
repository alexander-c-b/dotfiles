#!/usr/bin/env runhaskell
{-# LANGUAGE OverloadedStrings #-}
import              Data.List               (foldl',intersperse)
import              Data.Text               (Text)
import qualified    Data.Text               as T
import              Data.Char               (isAlpha,isSpace,isDigit)
import              Text.Pandoc.Definition  (Inline(Math,Span),Block(Div))
import              Text.Pandoc.JSON        (toJSONFilter)
import              Text.Pandoc.Walk        (walk)

main :: IO ()
main = toJSONFilter switchBlock

switchBlock :: Block -> Block
switchBlock orig@(Div attrs@(_, classes, _) children)
  | "asciimath" `elem` classes = Div attrs $ walk asciimath children
  | otherwise = orig
switchBlock x = x

asciimath :: Inline -> Inline
asciimath (Math t math) = Math t $
        "{" <> "\\asciimath{" <> replaced <> "}}"
    where replaced = replaceText "`" mathOps $
                        replaceText "\"" (between "text(" ")") math
asciimath x = x

replaceText :: Text -> (Text -> Text) -> Text -> Text
replaceText split f t = snd $ foldl' helper (False, "") (T.splitOn split t)
    where helper :: (Bool, Text) -> Text -> (Bool, Text)
          helper (replace, soFar) current =
              (not replace, soFar <> if replace
                                        then f current
                                        else current)

array :: Text -> Text -> Text
array split t = if length items > 1 then array_ items else t

    where items  = filter (not . T.null) $ map T.strip $ T.lines t
          array_ = between "{:(" "):}" 
                 . T.intercalate "), ("
                 . map (T.replace split $ "," <> split <> ",")

addSpace :: Text -> Text
addSpace = ("{:text( ):}" <>)

isTextChar :: Char -> Bool
isTextChar x = isAlpha x || isSpace x

mathOps :: Text -> Text
mathOps t = between "{:" ":}" $ case T.stripPrefix "|" t of
              Just rest -> mathOps_ rest
              Nothing   -> addSpace $ mathOps_ t
    where quote t = case (isTextChar . fst) <$> T.uncons t of
                      Just True -> "{:text(" <> t <> "):}"
                      _ -> t
          mathOps_ = T.concat . map quote 
                   . T.groupBy (\c1 c2 -> all isTextChar [c1, c2])

between :: Text -> Text -> Text -> Text
between left right text = left <> text <> right
