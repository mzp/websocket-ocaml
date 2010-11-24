(* -*- coding: utf-8 -*- *)
(** 簡易WebSocketサーバ *)

(** 簡易ロガー *)
module Logger : sig
  (**{3 ログレベル} *)

  (** ログレベル *)
  type t

  (** エラーのみ *)
  val cError : t

  (** エラーと情報 *)
  val cInfo  : t

  (** エラーと情報とデバッグ情報 *)
  val cDebug : t

  (**{3 ログ出力} *)
  (** 出力レベルがError,Info,Debugなら出力 *)
  val error : string -> unit

  (** 出力レベルがInfo,Debugなら出力 *)
  val info : string -> unit

  (** 出力レベルがDebugなら出力 *)
  val debug : string -> unit

  (**{3 設定} *)
  (** 出力レベルの設定 *)
  val set_level : t -> unit

  (** ログを吐く方法の指定。(複数指定できる) *)
  val add_handler : (string -> unit) -> unit

  (** デフォルトの出力レベル、Handlerに設定する *)
  val setup : unit -> unit
end


(** サーバ・クライアント間のデータ交換に使われるフレーム

    WebSocketではサーバ・クライアントの間のデータ交換は、フレーム単位で行なわれる。
    このモジュールでは、そのフレームの操作を定義する。

    @see <http://tools.ietf.org/html/draft-ietf-hybi-thewebsocketprotocol-03>  The WebSocket protocol draft-ietf-hybi-thewebsocketprotocol-03
*)
module Frame : sig
  type t =
    | Text of string (** テキスト・フレーム *)

  (** [WebSocket.Frame.unpack s]はストリーム[s]からフレームを読み込む。*)
  val unpack : char Stream.t -> t

  (** [WebSocket.Frame.pack f]はフレーム[f]を文字列に変換する。

      返り値の文字列は非Ascii文字も含むことがある。 *)
  val pack : t -> string
end

(** グロブ・パターンマッチ

    グロブによるパターンマッチを提供します。
    ワイルドカードは[:name]のように[:]で始まり、マッチ後に名前によって参照できます。

    例:
    {ul
    {- [WebSocket.Glob.match_ ~pat:"/foo/bar" "/foo/bar"]: マッチ成功}
    {- [WebSocket.Glob.match_ ~pat:"/foo/bar" "/foo/baz"]: マッチ失敗}
    {- [WebSocket.Glob.match_ ~pat:"/foo/:name" "/foo/bar"]: マッチ成功。[name]で["bar"]を参照できる。 }
    }
 *)
module Glob : sig
  type t
  val match_ : pat:string -> string -> t option
  val fields : t -> (string * string) list
end

module Dsl : sig
  type t
  val server :
    (< get : string -> (Glob.t -> string) -> unit;
       ws : string -> (Glob.t -> < read : Frame.t; send : Frame.t -> unit > -> unit) -> unit > -> 'a) -> t
  val html : string -> string
end

module Server : sig
  val run : Dsl.t -> string -> int -> unit
end

