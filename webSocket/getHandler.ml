open Base

let handle f glob ctx =
  ctx#send @@ HttpResponse.to_string {
    HttpResponse.version = "1.1";
    status = "200 OK";
    fields = ["Connection", "close"];
    body = f glob
  }
