open Base

type t =
    Error | Info | Debug

let cError,cInfo,cDebug =
  Error, Info, Debug

let level =
  ref cError

let set_level l =
  level := l

let handler =
  ref []

let add_handler f =
  handler := f :: !handler

let time =
  ref None

let __set_time t =
  time := Some t

let __reset_time _ =
  time := None

let setup () =
  set_level cError;
  add_handler print_endline

let time () =
  match !time with
      Some t -> t
    | None   -> Unix.time ()

let format_time t =
  let { Unix.tm_year; tm_mon; tm_mday; tm_hour; tm_min; tm_sec; _} =
    Unix.localtime t in
    Printf.sprintf "%4d-%02d-%02d %02d:%02d:%02d"
      (tm_year + 1900)
      (tm_mon + 1)
      tm_mday
      tm_hour
      tm_min
      tm_sec

let output prefix l s =
  if l <= !level then
    let log =
      Printf.sprintf "[%s] %s %s" (format_time @@ time ()) prefix s in
      List.iter (flip (@@) log) !handler

let error = output "ERROR" cError
let info  = output "INFO" cInfo
let debug = output "DEBUG" cDebug
