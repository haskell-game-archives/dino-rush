module DinoRush.Config
  ( Config (..),
    Resources (..),
  )
where

import DinoRush.Resource
import qualified SDL

data Config = Config
  { cWindow :: SDL.Window,
    cRenderer :: SDL.Renderer,
    cResources :: Resources
  }
