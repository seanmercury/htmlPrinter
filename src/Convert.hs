module Convert where

import qualified Markup
import qualified Html

convertStructure :: Markup.Structure -> Html.Structure
convertStructure structure =
  case structure of
    Markup.Heading nat txt ->
      Html.h_ nat txt

    Markup.Paragraph p ->
      Html.p_ p

    Markup.UnorderedList list ->
      Html.ul_ $ map Html.p_ list

    Markup.OrderedList list ->
      Html.ol_ $ map Html.p_ list

    Markup.CodeBlock list ->
      Html.code_ (unlines list)

concatStructure :: [Markup.Structure] -> [Html.Structure]
concatStructure [] = [Html.empty_]
concatStructure (s:ss) = convertStructure s : concatStructure ss


convert :: Html.Title -> Markup.Document -> Html.Html
convert title = Html.html_ title . foldMap convertStructure