module GregPoints

import Crypto.Block
import Crypto.Chain

%default total

mainchain : Maybe Chain
mainchain = addToChain genesis $ hash x

main : IO ()
main = do
        printLn (show mainchain)
