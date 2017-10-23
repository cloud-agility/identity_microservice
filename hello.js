let express = require('express');
let app = express();
let port = 3030;

app.get("/", (req, res) => res.json({message: "Hello World!"}));

app.listen(port, () => console.log("Running on port %s", port));

module.exports = app;
