# Full-stack Todo app in ONE file
node Todo {
    has text: str;
}

walker:pub create_todo {
    has text: str;
    can create with `root entry {
        here ++> Todo(text=self.text);
    }
}

walker:pub get_todos {
    can fetch with `root entry {
        report [-->(`?Todo)];
    }
}

# Frontend React component in Jac
cl {
    def:pub app() -> any {
        has todos: list = [];
        has text: str = "";

        async def addTodo() -> None {
            create_todo(
                text=text
            ) spawn root;
            text = "";
            result = get_todos() spawn root;
            todos = result.reports[0];
        }

        return (
            <div>
                <h1>Todo List</h1>
                <input value={text}
                    onChange={
                      lambda e: any -> None {text = e.target.value;}
                    }
                />
                <button onClick={addTodo}>Add Todo</button>
                <ul>
                    {todos.map(lambda todo: any -> any {
                        return <li>{todo.text}</li>;
                    })}
                </ul>
            </div>,
        );
    }
}
# Backend + Frontend in one file!