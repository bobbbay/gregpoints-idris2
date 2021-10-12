module Crypto.Chain

import Crypto.Block

public export
Chain : Type
Chain = List SafeBlock

||| Given an existing chain and a block, create a new one that appends the two.
||| If the given block fails to prove work, Nothing is returned.
export
addToChain : Chain -> SafeBlock -> Maybe Chain
addToChain chain blk = case (proveWork blk) of
                            True => Just (chain ++ [blk])
                            False => Nothing

export
genesis : List SafeBlock
genesis = [ hash x ]
