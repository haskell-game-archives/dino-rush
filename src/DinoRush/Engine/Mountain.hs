{-# LANGUAGE LambdaCase #-}
{-# LANGUAGE OverloadedStrings #-}

module DinoRush.Engine.Mountain where

import qualified Animate
import Data.Text (Text)

data MountainKey
  = MountainKey'Idle
  deriving (Show, Eq, Ord, Bounded, Enum)

instance Animate.KeyName MountainKey where
  keyName = mountainKey'keyName

mountainKey'keyName :: MountainKey -> Text
mountainKey'keyName = \case
  MountainKey'Idle -> "Idle"
