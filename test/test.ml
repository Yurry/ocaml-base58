open Base58
open OUnit2

let test_btc ctx =
  let addr = "mjVrE2kfz42sLR5gFcfvG6PwbAjhpmsKnn" in
  let addr_encoded = of_string_exn addr in
  let addr_decoded = to_string addr_encoded in
  assert_equal addr addr_decoded ;
  let addr_bytes = to_bytes_exn addr_encoded in
  let addr_bytes_decoded = of_bytes addr_bytes in
  assert_equal addr_encoded addr_bytes_decoded ;
  assert_equal '\x6f' (String.get addr_bytes 0) ;
  let ({ Bitcoin.version ; payload } as versioned) =
    Bitcoin.of_string_exn addr in
  assert_equal Bitcoin.Testnet_P2PKH version ;
  assert_equal 20 (String.length payload) ;
  let addr_versioned_str = Bitcoin.to_string versioned in
  assert_equal addr addr_versioned_str

let test_tezos ctx =
  let addr = "tz1e5dbxuQ1VBCTvr7DUdahymepWcmFjZcoF" in
  let addr_bytes = to_bytes_exn (`Base58 addr) in
  let addr' = of_bytes addr_bytes in
  assert_equal (`Base58 addr) addr' ;
  let tezos_addr = Tezos.of_base58_exn addr' in
  let tezos_addr' = Tezos.to_string tezos_addr in
  assert_equal tezos_addr' addr ;
  let addr' = Tezos.(of_string_exn addr |> to_string) in
  assert_equal addr addr'

let suite =
  "base58" >::: [
    "test_btc" >:: test_btc ;
    "test_tezos" >:: test_tezos ;
  ]

let () = run_test_tt_main suite
