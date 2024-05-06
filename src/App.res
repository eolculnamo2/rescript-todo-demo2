module State = {
  type t = {
    newInputValue: string,
    todos: array<Todo.t>,
  }

  type actions = Add | Delete(Todo.todoId) | ToggleDone(Todo.todoId) | InputUpdated(string)

  let initialState = {
    newInputValue: "",
    todos: [],
  }

  let reducer = (state, action): t => {
    switch action {
    | Add => {
        newInputValue: "",
        todos: [...state.todos, Todo.make(~label=state.newInputValue)],
      }
    | Delete(id) => {
        ...state,
        todos: state.todos->Array.filter(todo => todo.id != id),
      }
    | ToggleDone(id) => {
        ...state,
        todos: state.todos->Array.map(todo => {
          if todo.id != id {
            todo
          } else {
            {...todo, done: !todo.done}
          }
        }),
      }
    | InputUpdated(newValue) => {
        ...state,
        newInputValue: newValue,
      }
    }
  }
}

@react.component
let make = () => {
  let (state, dispatch) = React.useReducer(State.reducer, State.initialState)
  <div className="p-6">
    <h1 className="text-3xl font-semibold"> {"Todo List"->React.string} </h1>
    <input
      value=state.newInputValue
      onChange={e => {
        ReactEvent.Form.currentTarget(e)["value"]->InputUpdated->dispatch
      }}
    />
    <Button onClick={_ => dispatch(Add)}> {React.string("Add Todo")} </Button>
    {state.todos
    ->Array.map(todo => {
      <div
        role="button"
        onClick={_ => dispatch(ToggleDone(todo.id))}
        onDoubleClick={_ => dispatch(Delete(todo.id))}
        style={ReactDOM.Style.make(~color=todo.done ? "red" : "#333", ())}>
        {React.string(todo.label)}
      </div>
    })
    ->React.array}
  </div>
}
