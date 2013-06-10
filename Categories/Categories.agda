{-# OPTIONS --universe-polymorphism #-}
module Categories.Categories where

open import Level
open import Relation.Binary using (module IsEquivalence)

open import Categories.Operations
open import Categories.Category
open import Categories.Functor

Categories : ∀ o a → Category (suc (o ⊔ a)) (o ⊔ a)
Categories o a = record 
  { Obj = Category o a
  ; _⇒_ = Functor
  ; compose = _∘_
  ; id = id
  ; ASSOC = λ F G H → assoc {F = F} {G} {H}
  ; IDENTITYˡ = λ F → identityˡ {F = F}
  ; IDENTITYʳ = λ F → identityʳ {F = F}
  }

Categoriesᵉ : ∀ o a → EasyCategory (suc (o ⊔ a)) (o ⊔ a) (o ⊔ a)
Categoriesᵉ o a = UNEASY Categories o a WITH record
  { _≡_ = _≡_
  ; promote = promote
  ; REFL = λ f → Heterogeneous.refl _
  }

{-
module Agda where
  open import Category.Agda
  open import Category.Discrete

  D : ∀ o → Functor (Agda o) (Categories o o zero)
  D o = record 
    { F₀ = Discrete
    ; F₁ = λ f → record 
      { F₀ = λ x → f x
      ; F₁ = ≣-cong f
      ; identity = tt
      ; homomorphism = tt
      ; F-resp-≡ = λ _ → tt
      }
    ; identity = λ _ → refl tt
    ; homomorphism = λ _ → refl tt
    ; F-resp-≡ = F-resp-≡′
    }
    where
    F-resp-≡′ : {A B : Set o} {F G : A → B} → (∀ x → F x ≣ G x) → ∀ {X Y : A} (f : X ≣ Y) → [ Discrete B ] ≣-cong F f ∼ ≣-cong G f
    F-resp-≡′ {A} {B} {F} {G} f {x} ≣-refl = helper {F = F} {G} (f x)
      where
      helper : {F G : A → B} → {p q : B} → p ≣ q → [ Discrete B ] ≣-refl {x = p} ∼ ≣-refl {x = q}
      helper ≣-refl = refl tt

  Ob : ∀ o → Functor (Categories o o zero) (Agda o)
  Ob o = record 
    { F₀ = Category.Obj
    ; F₁ = Functor.F₀
    ; identity = λ _ → ≣-refl
    ; homomorphism = λ _ → ≣-refl
    ; F-resp-≡ = λ {_} {_} {F} {G} → F-resp-≡′ {F = F} {G}
    }
    where
    F-resp-≡′ : {A B : Category o o zero} {F G : Functor A B} 
              → ({X Y : Category.Obj A} (f : Category.Hom A X Y) → [ B ] Functor.F₁ F f ∼ Functor.F₁ G f)
              → ((x : Category.Obj A) → Functor.F₀ F x ≣ Functor.F₀ G x)
    F-resp-≡′ {A} {B} {F} {G} F∼G x = helper (F∼G (Category.id A {x}))
      where
      helper : ∀ {X Y} {p : Category.Hom B X X} {q : Category.Hom B Y Y} → [ B ] p ∼ q → X ≣ Y
      helper (refl q) = ≣-refl

  open import Category.Adjunction

  D⊣Ob : ∀ o → Adjunction (D o) (Ob o)
  D⊣Ob o = record 
    { unit = record 
      { η = λ _ x → x
      ; commute = λ _ _ → ≣-refl
      }
    ; counit = record 
      { η = λ X → record 
        { F₀ = λ x → x
        ; F₁ = counit-id′ {X}
        ; identity = IsEquivalence.refl (Category.equiv X)
        ; homomorphism = {!!}
        ; F-resp-≡ = {!!}
        }
      ; commute = {!!}
      }
    ; zig = {!!}
    ; zag = λ _ → ≣-refl
    }
    where
    counit-id′ : {X : Category o o zero} → {A B : Category.Obj X} → A ≣ B → Category.Hom X A B
    counit-id′ {X} ≣-refl = Category.id X
-}
