{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE LambdaCase        #-}
import              Data.Text               ()
import              Text.Pandoc.JSON        (toJSONFilter)
import              Text.Pandoc.Definition  (Inline(Strong,Underline,Span))

main :: IO ()
main = toJSONFilter $
        \case (Strong xs) -> Underline xs
              (Span (_, classes, _) xs) | "strong" `elem` classes -> Strong xs
              x -> x
