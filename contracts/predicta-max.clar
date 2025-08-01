;; PredictaMax: Advanced Cryptocurrency Price Prediction Platform
;;
;; Summary: A sophisticated decentralized prediction market enabling users to forecast Bitcoin price movements
;; with competitive staking mechanisms, automated reward distribution, and oracle-based price resolution.
;;
;; Description: PredictaMax revolutionizes crypto price predictions by combining blockchain transparency with
;; advanced market mechanics. Users stake STX tokens on their Bitcoin price predictions (up/down) within
;; time-bounded markets. Winners share the total pool proportionally to their stakes, minus platform fees.
;; Oracle-verified price feeds ensure accurate market resolution, while smart contract automation guarantees
;; trustless and transparent reward distribution across all participants.

;; CONSTANTS & ERROR DEFINITIONS

(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))
(define-constant err-not-found (err u101))
(define-constant err-invalid-prediction (err u102))
(define-constant err-market-closed (err u103))
(define-constant err-already-claimed (err u104))
(define-constant err-insufficient-balance (err u105))
(define-constant err-invalid-parameter (err u106))

;; DATA VARIABLES

(define-data-var oracle-address principal 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM)
(define-data-var minimum-stake uint u1000000) ;; 1 STX minimum stake
(define-data-var fee-percentage uint u2) ;; 2% platform fee
(define-data-var market-counter uint u0)

;; DATA MAPS

(define-map markets
  uint
  {
    start-price: uint,
    end-price: uint,
    total-up-stake: uint,
    total-down-stake: uint,
    start-block: uint,
    end-block: uint,
    resolved: bool,
  }
)

(define-map user-predictions
  {
    market-id: uint,
    user: principal,
  }
  {
    prediction: (string-ascii 4),
    stake: uint,
    claimed: bool,
  }
)

;; PUBLIC FUNCTIONS

;; Creates a new prediction market with specified parameters
(define-public (create-market
    (start-price uint)
    (start-block uint)
    (end-block uint)
  )
  (let ((market-id (var-get market-counter)))
    ;; Validation checks
    (asserts! (is-eq tx-sender contract-owner) err-owner-only)
    (asserts! (> end-block start-block) err-invalid-parameter)