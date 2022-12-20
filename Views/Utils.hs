module Views.Utils( blaze,pet) where

import           Text.Blaze.Html.Renderer.Text (renderHtml)
import           Text.Blaze.Html (Html, preEscapedText)
import           Web.Scotty (ActionM, html)
import           Data.Text (Text)

pet:: Text -> Html
pet = preEscapedText

blaze :: Html -> ActionM ()
blaze = html . renderHtml

