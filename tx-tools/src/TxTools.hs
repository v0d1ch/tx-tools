{-# LANGUAGE NamedFieldPuns #-}

module TxTools where

import Cardano.Api

type Transaction = Tx ShelleyEra

replaceTransactionInputs :: [(TxIn, BuildTxWith build (Witness WitCtxTxIn era))] -> Tx era -> Tx era 
replaceTransactionInputs newTxInputs (Tx body wits) =
  let newTxIns = newTxInputs
   in Tx (TxBody (bodyContent{txIns = newTxInputs})) wits
 where
  TxBody bodyContent = body
  TxBodyContent{txIns} = bodyContent
