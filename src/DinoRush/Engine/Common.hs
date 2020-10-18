{-# LANGUAGE TemplateHaskell #-}

module DinoRush.Engine.Common where

import Control.Lens
import DinoRush.Engine.Quake
import DinoRush.Engine.Sfx
import DinoRush.Engine.Types

data CommonVars = CommonVars
  { cvHiscore :: Score,
    cvQuake :: Quake,
    cvSfx :: [Sfx]
  }
  deriving (Show, Eq)

makeClassy ''CommonVars

initCommonVars :: CommonVars
initCommonVars = CommonVars 0 (Quake'Dormant 2) []
