const TodoService = require('../services/todo.service')

const todoController = {
    handleCreate: async (req, res, next) => {
        const { userId, title, desc } = req.body
        await TodoService.createTodo(userId, title, desc)
            .then(todo => res.json({ status: true, todo }))
            .catch(next)
    },

    handleRead: async (req, res, next) => {
        const { userId } = req.query
        await TodoService.readTodo(userId)
            .then(todos => {
                res.status(200).json({
                    todos
                })
            })
            .catch(next)
    },

    handleUpdate: async (req, res, next) => {
        const _id = req.params.id
        const { title, desc } = req.body
        await TodoService.updateTodo(_id, title, desc)
            .then(todo => {
                res.status(200).json({
                    status: true, todo
                })
            })
            .catch(next)
    },

    handleDelete: async (req, res, next) => {
        const _id = req.params.id
        console.log(_id);
        await TodoService.deleteTodo(_id)
            .then(todo => {
                res.status(200).json({
                    status: true, todo
                })
            })
            .catch(next)
    },
}

module.exports = todoController
