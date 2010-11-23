(* -*- coding: utf-8 -*- *)
(** WebSocketモジュール *)

(** WebSocketのデータ交換に使うモジュール *)
module Frame : sig
  type t =
    | Text of string

  val unpack : char Stream.t -> t
  val pack : t -> string
end

(** Globパターンマッチ *)
module Glob : sig
  type t
  val fields : t -> (string * string) list
end

module Dsl : sig
  type t
  val server :
    (< get : string -> (Glob.t -> string) -> unit;
     ws : string ->
						   (Glob.t -> < read : Frame.t; send : Frame.t -> unit > -> unit) ->
						   unit > -> 'a) -> t
  val html : string -> string
end

module Server : sig
  val run : Dsl.t -> string -> int -> unit
end

module Logger : sig
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
end
