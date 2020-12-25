#!/usr/bin/env runhaskell
{- For quick Mom/Dad/Swas chord sheets -}
{-# LANGUAGE OverloadedStrings #-}
import           Data.Maybe             (isJust)
import           Data.List              (intersperse,stripPrefix,maximum)
import           Data.List.Split        (splitOn)
import           Text.Pandoc.Definition (Block(CodeBlock,Table,Plain)
                                        ,Inline(Superscript,Str)
                                        ,Alignment(AlignCenter)
                                        ,TableCell)
import           Text.Pandoc.JSON       (toJSONFilter)

toCellString :: String -> [String]
toCellString t = f $ words t
    where f  = if isJust (stripPrefix " " t)
                  then ("" :)
                  else id
                  
wrap :: String -> TableCell
wrap = map Plain 
     . (: [])
     . filter (/= Str "")
     . intersperse (Superscript [Str "m"]) 
     . map Str
     . splitOn "-"

chords :: Block -> Block
chords (CodeBlock (_, classes, _) text)
  | "chords" `elem` classes = 
      Table [] (replicate n AlignCenter) (replicate n 0) [] table
          where table = map (map wrap . toCellString) $ lines text
                n     = maximum $ map length table
chords x = x

main :: IO ()
main = toJSONFilter chords
