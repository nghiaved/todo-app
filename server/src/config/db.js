const mongoose = require('mongoose')

const urlMongodb = 'mongodb://localhost:27017/todo-app'

const connectDB = () => {
    try {
        mongoose.set('strictQuery', false)
        mongoose.connect(urlMongodb, {
            useNewUrlParser: true,
            useUnifiedTopology: true,
        })
        console.log('Connect successfully!')
    } catch (error) {
        console.log('Connect failure!')
    }
}

module.exports = connectDB
