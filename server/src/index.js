const express = require('express')
const bodyParser = require('body-parser')
const cors = require('cors')

const connectDB = require('./config/db')
const routes = require('./routes')

const app = express()
const PORT = 7000

connectDB()

app.use(cors())

app.use(bodyParser.json({ limit: "50mb" }))
app.use(bodyParser.urlencoded({ limit: "50mb", extended: true, parameterLimit: 50000 }))

routes(app)

app.listen(PORT, () => console.log(`App listening at http://localhost:${PORT}`))
