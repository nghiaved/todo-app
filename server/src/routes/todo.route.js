const express = require('express')

const todoController = require('../controllers/todo.controller')

const router = express.Router()

const todoRoute = app => {
    router.post('/create', todoController.handleCreate)
    router.get('/read', todoController.handleRead)
    router.put('/update/:id', todoController.handleUpdate)
    router.delete('/delete/:id', todoController.handleDelete)

    return app.use('/api/todo', router)
}

module.exports = todoRoute
