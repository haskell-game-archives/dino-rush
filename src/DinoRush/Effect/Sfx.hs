{-# LANGUAGE LambdaCase #-}
{-# LANGUAGE NamedFieldPuns #-}

module DinoRush.Effect.Sfx where

import Control.Lens
import Control.Monad.State
import DinoRush.Effect.Audio
import DinoRush.Engine.Common
import DinoRush.Engine.Sfx

class Monad m => AudioSfx m where
  clearSfx :: m ()
  addSfxs :: [Sfx] -> m ()
  playSfx :: m ()

clearSfx' :: (HasCommonVars s, MonadState s m) => m ()
clearSfx' = modify $ commonVars %~ (\cv -> cv {cvSfx = []})

addSfxs' :: (HasCommonVars s, MonadState s m) => [Sfx] -> m ()
addSfxs' sfxs = modify $ commonVars %~ (\cv -> cv {cvSfx = sfxs ++ cvSfx cv})

playSfx' :: (Audio m, HasCommonVars s, MonadState s m) => m ()
playSfx' = do
  CommonVars {cvSfx} <- gets (view commonVars)
  forM_ cvSfx $ \case
    Sfx'Jump -> playJumpSfx
    Sfx'Duck -> playDuckSfx
    Sfx'Point -> playPointSfx
    Sfx'Bird -> playBirdSfx
    Sfx'Hurt -> playHurtSfx
    Sfx'Lava -> playLavaSfx
    Sfx'Quake -> playQuakeSfx
    Sfx'Rock -> playRockSfx
    Sfx'Recover -> playRecoverSfx
    Sfx'Stock -> playStockSfx
