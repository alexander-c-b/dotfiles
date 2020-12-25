#!/usr/bin/env runhaskell
import              Data.List.Split         (splitOn)
import              Data.List               (foldl')
import              Data.Traversable        (for)
import              Text.Pandoc.Definition  (Inline(Math,Span),Block(Div))
import              Text.Pandoc.JSON        (toJSONFilter)
import              Text.Pandoc.Walk        (walk)

main :: IO ()
main = toJSONFilter $ array

switchBlock :: Bool  -- asciimath class found yet
            -> Block -> Block
switchBlock found orig@(Div attrs@(_, classes, _) children)
  | not found && ("asciimath" `elem` classes) = Div attrs $ walk (switchBlock True) children
  |     found && ("array"     `elem` classes) = Div attrs $ walk array children
  | otherwise = orig
switchBlock _ x = x

array :: Inline -> Inline
array (Math t math) = Math t $ 
    case splitOn "=" math of
      (first:second:rest) | not (null rest) ->
        "{: (" <> first <> ", = ," <> second <> ")" <> 
            concatMap (\s -> ", (, =, " <> s <> ")") rest
            <> ":}"
      _ -> math
array x = x
