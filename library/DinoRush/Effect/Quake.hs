module DinoRush.Effect.Quake where

import Control.Lens
import Control.Monad.State (MonadState(..), modify, gets)

import DinoRush.Effect.Sfx
import DinoRush.Engine.Common
import DinoRush.Engine.Quake
import DinoRush.Engine.Step
import DinoRush.Engine.Sfx

updateQuake :: (AudioSfx m, MonadState s m, HasCommonVars s) => m ()
updateQuake = do
  sq <- gets (stepQuake . cvQuake . view commonVars)
  addSfxs $ [Sfx'Quake | startQuake sq]
  modify $ commonVars %~ (\cv -> cv{ cvQuake = smash sq })
