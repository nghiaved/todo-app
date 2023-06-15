const mongoose = require('mongoose')

const UserModel = require('./user.model')

const Schema = mongoose.Schema

const todoSchema = new Schema({
    title: {
        type: String,
        required: true,
    },
    desc: {
        type: String,
        required: true,
    },
    userId: {
        type: Schema.Types.ObjectId,
        ref: UserModel.modelName,
    },
}, {
    timestamps: true,
})

module.exports = mongoose.model('todo', todoSchema)
