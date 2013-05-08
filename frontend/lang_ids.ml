open Core.Std

module Id = (Int63 : Id_intf.Generators)

type ('c, 'u) t = Id.t * 'u Lang_types.t

type 'c t_box = Box : ('c, _) t -> 'c t_box

(* explicit polymorphism; we need System F types in lang_concrete *)
type 'i t_arrow_type =
  { a_f : 't . ('i, 't) t -> 't Lang_types.t }

module type Generators = sig
  type c
  val gen_id  :  'u Lang_types.t -> (c, 'u) t
end

module type Accessors = sig
  type c
  val type_of_t  :  (c, 'u) t -> 'u Lang_types.t
  val type_of_t'  :  c t_arrow_type
end

module type S = sig
  include Generators
  include Accessors with type c := c
end

module Make (U : Unit.S) : S = struct

  type c

  let m = Hashtbl.Poly.create () ~size:1024

  let gen_id :
  type u . u Lang_types.t -> (c, u) t =
    fun x ->
      let x' = Lang_types.Box x in
      match Hashtbl.find m x' with
      | Some id ->
        Hashtbl.change m x' (Option.map ~f:Id.succ);
        id, x
      | None ->
        Hashtbl.replace m x' (Id.succ Id.zero); Id.zero, x

  let type_of_t :
  type u . (c, u) t -> u Lang_types.t =
    Tuple.T2.get2

  let type_of_t' = { a_f = type_of_t }

end