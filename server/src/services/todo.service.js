const todoModel = require('../models/todo.model')

class TodoService {
    static async createTodo(userId, title, desc) {
        const createTodo = new todoModel({ userId, title, desc })
        const todo = await createTodo.save()
        return todo
    }

    static async readTodo(userId) {
        const todos = await todoModel.find({ userId })
        return todos
    }

    static async updateTodo(_id, title, desc) {
        const todo = await todoModel.updateOne({ _id }, { title, desc })
        return todo
    }

    static async deleteTodo(_id) {
        const todo = await todoModel.findOneAndDelete({ _id })
        return todo
    }

}

module.exports = TodoService
