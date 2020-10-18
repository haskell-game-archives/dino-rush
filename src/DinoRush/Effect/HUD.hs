module DinoRush.Effect.HUD where

import Control.Lens (view)
import Control.Monad (when)
import Control.Monad.State (MonadState, gets)
import DinoRush.Effect.Renderer
import DinoRush.Engine.Common
import DinoRush.Engine.Font
import DinoRush.Engine.Play

class Monad m => HUD m where
  drawHiscore :: m ()
  drawScore :: m ()
  drawControls :: m ()

drawHiscore' :: (Renderer m, MonadState s m, HasCommonVars s) => m ()
drawHiscore' = do
  cv <- gets (view commonVars)
  drawHiscoreText (1150, 16)
  drawNumbers (fromIntegral $ cvHiscore cv) (1234, 50)

drawScore' :: (Renderer m, MonadState s m, HasPlayVars s) => m ()
drawScore' = do
  pv <- gets (view playVars)
  drawNumbers (fromIntegral $ pvScore pv) (1234, 100)

drawControls' :: (Renderer m, MonadState s m, HasPlayVars s) => m ()
drawControls' = do
  pv <- gets (view playVars)
  when (pvSeconds pv < 2) $ drawControlsText (200, 470)

drawNumbers :: Renderer m => Integer -> (Int, Int) -> m ()
drawNumbers int (x, y) =
  mapM_
    (\(i, n) -> drawNumber n (x - i * 16, y))
    (zip [0 ..] (toNumberReverse int))
