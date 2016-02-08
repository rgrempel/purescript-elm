module Elm.Set 
    ( module Virtual
    , remove, intersect, diff
    , filter, partition, map
    ) where


-- For re-export

import Data.Set
    ( Set, empty, singleton, insert
    , isEmpty, member, size
    , toList, fromList
    , union
    ) as Virtual

import Data.Foldable (foldr) as Virtual
import Elm.Foldable (foldl) as Virtual


-- Internal

import Prelude (class Ord, flip, (<<<))
import Data.Set (Set, delete, difference, intersection, fromList, toList, insert, empty)
import Data.Foldable (foldr)
import Elm.Foldable (foldl)


{-| Remove a value from a set. If the value is not found, no changes are made. -}
remove :: forall a. (Ord a) => a -> Set a -> Set a
remove = delete


{-| Get the intersection of two sets. Keeps values that appear in both sets. -}
intersect :: forall a. (Ord a) => Set a -> Set a -> Set a
intersect = intersection


{-| Get the difference between the first set and the second. Keeps values
that do not appear in the second set.
-}
diff :: forall a. (Ord a) => Set a -> Set a -> Set a
diff = difference


{-| Map a function onto a set, creating a new set with no duplicates. -}
map :: forall a b. (Ord a, Ord b) => (a -> b) -> Set a -> Set b
map func set =
    foldl (\a memo -> insert (func a) memo) empty set


{-| Create a new set consisting only of elements which satisfy a predicate. -}
filter :: forall a. (Ord a) => (a -> Boolean) -> Set a -> Set a
filter func =
    fromList <<< Data.List.filter func <<< toList 


{-| Create two new sets; the first consisting of elements which satisfy a
predicate, the second consisting of elements which do not.
-}
partition :: forall a. (Ord a) => (a -> Boolean) -> Set a -> {trues :: Set a, falses :: Set a}
partition pred set =
    foldr step { trues: empty, falses: empty } set 
        where
            step x memo =
                if pred x
                    then memo { trues = insert x memo.trues }
                    else memo { falses = insert x memo.falses }
