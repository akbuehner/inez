module type Term = sig

  type _ a

  type ('i, _) t =
  | M_Bool  :  'i a Formula.t ->
    ('i, bool) t
  | M_Int   :  Core.Std.Int63.t ->
    ('i, int) t
  | M_Sum   :  ('i, int) t * ('i, int) t ->
    ('i, int) t
  | M_Prod  :  Core.Std.Int63.t * ('i, int) t ->
    ('i, int) t
  | M_Ite   :  'i a Formula.t * ('i, int) t * ('i, int) t ->
    ('i, int) t
  | M_Var   :  ('i, 's) Lang_ids.t ->
    ('i, 's) t
  | M_App   :  ('i, 'r -> 's) t * ('i, 'r) t ->
    ('i, 's) t

end

module type Term_with_ops = sig

  include Term

  val zero : ('a, int) t
  val one : ('a, int) t

  (* conversions *)

  val of_int63 : Core.Std.Int63.t -> ('a, int) t

  (* type utilities *)

  val type_of_t :
    ('i, 's) t -> f:'i Lang_ids.t_arrow_type -> 's Lang_types.t

  (* infix operators *)

  include (Ops_intf.Int with type ('i, 's) t := ('i, 's) t
                        and type i := Core.Std.Int63.t)

end

module type Atom = sig

  type (_, _) m

  type 'i t =
  | A_Bool  of  ('i, bool) m
  | A_Le    of  ('i, int) m
  | A_Eq    of  ('i, int) m

end