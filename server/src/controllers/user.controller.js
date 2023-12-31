const UserService = require('../services/user.service')

const userController = {
    handleResigter: async (req, res, next) => {
        const { fullName, email, password } = req.body
        await UserService.registerUser(fullName, email, password)
            .then(() => {
                res.json({ status: true, success: 'User Registed Successfully' })
            })
            .catch(next)
    },

    handleLogin: async (req, res, next) => {
        const { email, password } = req.body
        await UserService.checkEmail(email)
            .then(async (user) => {
                if (!user) {
                    throw new Error(`User don't exist`)
                }

                const isMatch = await user.comparePassword(password)
                if (isMatch === false) {
                    throw new Error(`Password invalid`)
                }

                let tokenData = { _id: user._id, fullName: user.fullName, email: user.email, image: user.image }
                const token = await UserService.generateToken(tokenData, 'secretKey', '1d')

                res.status(200).json({ status: true, token })
            })
            .catch(next)
    },

    handleUpdate: async (req, res, next) => {
        const _id = req.params.id
        const { fullName, email, password, image } = req.body
        await UserService.updateUser(_id, fullName, email, password, image)
            .then(async (user) => {
                let tokenData = { _id, fullName, email, image }
                const token = await UserService.generateToken(tokenData, 'secretKey', '1d')
                res.status(200).json({ status: true, token })
            })
            .catch(next)
    },
}

module.exports = userController
