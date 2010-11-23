(* -*- coding: utf-8 -*- *)
type t
val cError : t
val cInfo  : t
val cDebug : t

(** 出力レベルの設定 *)
val set_level : t -> unit

(** ログを吐く方法の指定。(複数指定できる) *)
val add_handler : (string -> unit) -> unit

(** デフォルトの出力レベル、Handlerに設定する *)
val setup : unit -> unit

(** 出力レベルがError,Info,Debugなら出力 *)
val error : string -> unit

(** 出力レベルがInfo,Debugなら出力 *)
val info : string -> unit

(** 出力レベルがDebugなら出力 *)
val debug : string -> unit

val __set_time : float -> unit
