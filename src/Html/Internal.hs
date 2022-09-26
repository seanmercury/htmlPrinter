module Html.Internal where

import Numeric.Natural

newtype Html = Html String

newtype Structure = Structure String

empty_ :: Structure
empty_ = Structure ""

el :: String -> String -> String
el tag content =
    "<" <> tag <> ">" <> content <> "</" <> tag <> ">"

p_ :: String -> Structure
p_ = Structure . el "p" . escape

h1_ :: String -> Structure
h1_ = Structure . el "h1" . escape

h_ :: Natural -> String -> Structure
h_ na = Structure . (el ("h" ++ show na)) . escape

li_ :: String -> Structure
li_ = Structure . el "li" . escape

ul_ :: [Structure] -> Structure
ul_ structures = Structure . el "ul" $ concatMap (el "li" . getStructureString) structures

ol_ :: [Structure] -> Structure
ol_ structures = Structure . el "ol" $ concatMap (el "li" . getStructureString) structures

code_ :: String -> Structure
code_ = Structure . el "pre" . escape

type Title = String

html_ :: Title -> Structure -> Html
html_ title content =
    Html
        ( el
            "html"
            ( el "head" (el "title" (escape title))
                <> el "body" (getStructureString content)
            )
        )

escape :: String -> String
escape =
    let escapeChar c =
            case c of
                '<' -> "&lt;"
                '>' -> "&gt;"
                '&' -> "&amp;"
                '"' -> "&quot;"
                '\'' -> "&#39;"
                _ -> [c]
     in concatMap escapeChar

instance Semigroup Structure where
  (<>) c1 c2 = Structure (getStructureString c1 <> getStructureString c2)

instance Monoid Structure where
  mempty = empty_
  mconcat :: Monoid a => [a] -> a
  mconcat [] = mempty
  mconcat (s:ss) = s <> mconcat ss

render :: Html -> String
render (Html a) = a

getStructureString :: Structure -> String
getStructureString (Structure a) = a
