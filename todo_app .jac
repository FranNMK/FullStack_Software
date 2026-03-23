# Full-stack Todo app in ONE file

node Todo {
    has text: str;
    has category: Category = Category.UNCATEGORIZED;
}

enum Category { WORK, PERSONAL, SHOPPING, HEALTH, UNCATEGORIZED }

walker:pub create_todo {
    has text: str;
    can create with `root entry {
        # Use LLM to categorize the todo item
        category_result = categorize(title=self.text) by llm();
        here ++> Todo(text=self.text, category=category_result);
    }
}

walker:pub get_todos {
    can fetch with `root entry {
        report [-->(Todo)];
    }
}

# AI-native function to categorize a todo item
def categorize(title: str) -> Category
    by llm();
sem categorize = "Categorize the given task title into one of the predefined categories: WORK, PERSONAL, SHOPPING, HEALTH, or UNCATEGORIZED.";


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

        async def loadTodos() -> None {
            result = get_todos() spawn root;
            todos = result.reports[0];
        }

        can with entry {
            loadTodos();
        }

        return (
            <div>
                <h1>AI-Powered Todo List</h1>
                <input value={text}
                    onChange={
                        lambda e: any -> None {text = e.target.value;}
                    }
                />
                <button onClick={addTodo}>Add Todo</button>
                <ul>
                    {todos.map(lambda todo: any -> any {
                        return <li>[{todo.category}] {todo.text}</li>;
                    })}
                </ul>
            </div>
        );
    }
}
# Backend + Frontend in one file!
