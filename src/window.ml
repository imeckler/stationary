type 'a t = 'a option * 'a * 'a option

let create =
  let rec loop prev xs =
    match xs with
    | x1 :: x2 :: xs ->
      (prev, x1, Some x2) :: loop (Some x1) (x2 :: xs)
    | x1 :: [] ->
      [ prev, x1, None ]
    | [] -> []
  in
  fun xs ->
    match xs with
    | [] -> []
    | _ :: _ -> loop None xs
