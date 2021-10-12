module Crypto.Block

import Data.SOP
import Data.String

--  FIXME
||| A value containing a valid timestamp.
data Timestamp : Type
data Timestamp = Nat

--  FIXME
||| A hash type.
public export
data Hash : Type where
  SHA256 : String -> Hash

--  FIXME
||| Metadata for each block.
record Meta where
  constructor MkMeta
  description : Maybe String

||| This type is for internal usage, and allows the stacking of blocks as
||| outlined in github.com/stefan-hoeck/idris2-sop/src/Doc/Barbies.md.
|||
||| All Blocks based off of SkeletonBlock always contain:
|||  @ nonce : Nat (randomly generated number)
|||  @ timestamp : Timestamp (the time it was created)
|||  @ meta : Maybe Meta (optional meta information)
|||  @ prevHash : Maybe Hash (the preceding hash, sometimes doesn't exist)
|||
||| A SafeBlock will also contain hash : Hash, which is the hash of the current
||| block.
public export
SkeletonBlock : (hashType : Type) -> (f : Type -> Type) -> Type
SkeletonBlock hashType f = NP f [Nat, Nat, Meta, Maybe Hash, hashType]

||| This type is an unsafe Block. It contains all the values that a skeleton
||| Block does, but nothing more. Its `hash` is `: ()`.
|||
||| UnsafeBlock is meant for usage pre-hashing the block itself. It should
||| never be part of the chain.
public export
UnsafeBlock : Type
UnsafeBlock = SkeletonBlock () I

||| This type is a safe Block. It contains all the values that a skeleton Block
||| does, as well as its `hash : Hash`.
|||
||| SafeBlock is meant to be used in a chain.
public export
SafeBlock : Type
SafeBlock = SkeletonBlock Hash I

--  FIXME
||| Prove that work has been done to obtain a block.
export
proveWork : SafeBlock -> Bool
proveWork [_, _, _, _, h] = True

namespace Hash
  ||| Given an unsafe block and a hash, produce a safe block.
  export
  toSafe : UnsafeBlock -> Hash -> SafeBlock
  toSafe [n, t, m, p, _] hsh = [n, t, m, p, hsh]

  ||| Turns a SafeBlock into an unsafe one.
  ||| Warning: this function is lossy.
  export
  toUnsafe : SafeBlock -> UnsafeBlock
  toUnsafe [n, t, m, p, _] = [n, t, m, p, ()]

  --  FIXME
  ||| Produce a Hash from a Block.
  toHash : UnsafeBlock -> Hash
  toHash blk = SHA256 ""

  ||| Hash an UnsafeBlock to produce a SafeBlock.
  export
  hash : UnsafeBlock -> SafeBlock
  hash old = let hash = toHash old
             in toSafe old hash

public export
Show Meta where
  show _ = "META"

public export
Show Hash where
  show _ = "HASH"

public export
Show SafeBlock where
  show [n, t, m, p, h] = "nonce: " ++ show n
                      ++ " | timestamp: " ++ show t
                      ++ " | meta: " ++ show m
                      ++ " | prevhash: " ++ show p
                      ++ " | hash: " ++ show h

export
x : UnsafeBlock
x = [1, 1, MkMeta (Just ""), Nothing, ()]
