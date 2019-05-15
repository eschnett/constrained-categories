{-# LANGUAGE TemplateHaskell #-}

{-# OPTIONS_GHC -Wno-incomplete-patterns #-}

module PlainSpec where

import Control.Constrained.Category
import Control.Constrained.Plain
import Data.Binary
import Data.Coerce
import Data.Vector.Unboxed.Deriving
import GHC.Generics hiding (C)
import Test.QuickCheck



newtype A = A Int
        deriving (Eq, Ord, Read, Show, Generic)
        deriving (Arbitrary, Binary, CoArbitrary) via Int
derivingUnbox "A" [t| A -> Int |] [| coerce |] [| coerce |]
instance Function A

newtype B = B Int
        deriving (Eq, Ord, Read, Show, Generic)
        deriving (Arbitrary, Binary, CoArbitrary) via Int
derivingUnbox "B" [t| B -> Int |] [| coerce |] [| coerce |]
instance Function B

newtype C = C Int
        deriving (Eq, Ord, Read, Show, Generic)
        deriving (Arbitrary, Binary, CoArbitrary) via Int
derivingUnbox "C" [t| C -> Int |] [| coerce |] [| coerce |]
instance Function C



cmp :: Eq a => Show a => (a, a) -> Property
cmp (x, y) = x === y

fcmp :: Category k => Ok k a => Ok k b => Eq b => Show b
     => (k a b, k a b) -> a -> Property
fcmp (f, g) x = eval f x === eval g x



prop_PFun_Category_evalId :: A -> Property
prop_PFun_Category_evalId x = cmp $ law_Category_evalId @(-#>) x

prop_PFun_Category_leftId :: Fun A B -> A -> Property
prop_PFun_Category_leftId (Fn f) = fcmp $ law_Category_leftId @(-#>) (PFun f)

prop_PFun_Category_rightId :: Fun A B -> A -> Property
prop_PFun_Category_rightId (Fn f) = fcmp $ law_Category_rightId @(-#>) (PFun f)

prop_PFun_Category_assoc :: Fun C A -> Fun B C -> Fun A B -> A -> Property
prop_PFun_Category_assoc (Fn h) (Fn g) (Fn f) =
  fcmp $ law_Category_assoc @(-#>) (PFun h) (PFun g) (PFun f)



prop_PFun_Cartesian_leftUnit1 :: A -> Property
prop_PFun_Cartesian_leftUnit1 x = cmp $ law_Cartesian_leftUnit1 @(-#>) x

prop_PFun_Cartesian_leftUnit2 :: A -> Property
prop_PFun_Cartesian_leftUnit2 x = cmp $ law_Cartesian_leftUnit2 @(-#>) ((), x)

prop_PFun_Cartesian_rightUnit1 :: A -> Property
prop_PFun_Cartesian_rightUnit1 x = cmp $ law_Cartesian_rightUnit1 @(-#>) x

prop_PFun_Cartesian_rightUnit2 :: A -> Property
prop_PFun_Cartesian_rightUnit2 x = cmp $ law_Cartesian_rightUnit2 @(-#>) (x, ())

prop_PFun_Cartesian_assoc :: ((A, B), C) -> Property
prop_PFun_Cartesian_assoc p = cmp $ law_Cartesian_assoc @(-#>) p

prop_PFun_Cartesian_reassoc :: (A, (B, C)) -> Property
prop_PFun_Cartesian_reassoc p = cmp $ law_Cartesian_reassoc @(-#>) p

prop_PFun_Cartesian_swap :: (A, B) -> Property
prop_PFun_Cartesian_swap p = cmp $ law_Cartesian_swap @(-#>) p

prop_PFun_Cartesian_leftFork :: Fun A B -> Fun A C -> A -> Property
prop_PFun_Cartesian_leftFork (Fn f) (Fn g) =
  fcmp $ law_Cartesian_leftFork @(-#>) (PFun f) (PFun g)

prop_PFun_Cartesian_rightFork :: Fun A B -> Fun A C -> A -> Property
prop_PFun_Cartesian_rightFork (Fn f) (Fn g) =
  fcmp $ law_Cartesian_rightFork @(-#>) (PFun f) (PFun g)

prop_PFun_Cartesian_dup :: A -> Property
prop_PFun_Cartesian_dup = fcmp $ law_Cartesian_dup @(-#>)