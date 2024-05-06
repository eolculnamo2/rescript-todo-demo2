type todoId = int
type t = {
  id: todoId,
  done: bool,
  label: string,
}

let make = (~label: string): t => {
  id: Math.Int.random(0, Js.Int.max),
  done: false,
  label,
}
