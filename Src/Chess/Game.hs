module Chess.Game (
    GameState,
    Move, 
    changePlayer',
    movePiece,
    canPickUp,
    lost,
    won,
    showBoard,
    initialGameState
)

where 

import Chess.Movement
import Chess.Metrics
import Chess.Figures

type GameState = (Board, Player)
type Move = (Pos,Pos)

changePlayer' :: GameState -> GameState
changePlayer' = (\(b,p)->(b, changePlayer p))

movePiece :: GameState -> Move ->  GameState
movePiece g@(b,c) (s,e) = 
        if canPickUp s g
        then case f of
                (Just f') ->
                        let  m = moveTo b f' e
                        in case m of 
                            Just m' -> (m',changePlayer c) 
                            otherwise -> g
                otherwise -> g 
        else g -- Someone Tried to do something invalid - nothing happens
    where f = pieceOnPos b s

canPickUp:: Pos -> GameState -> Bool 
canPickUp p (b,c) = demaybiebool $ fmap (((==) c) . player) f
    where f = pieceOnPos b p

-- Helpers 
lost :: GameState -> Player -> Bool 
lost g@(b,c) c' = checkmate b c'
won g c = lost g (changePlayer c)

initialGameState = (initialBoard,W)

demaybiebool :: Maybe Bool -> Bool 
demaybiebool Nothing = False 
demaybiebool (Just x) = x

showBoard = printBoard