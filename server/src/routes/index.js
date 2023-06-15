const userRoute = require('./user.route')
const todoRoute = require('./todo.route')

const routes = app => {
    userRoute(app)
    todoRoute(app)
}

module.exports = routes
