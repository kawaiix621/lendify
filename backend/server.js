const express = require("express");
const bodyParser = require("body-parser");
const app = express();

app.use(bodyParser.json());

// Example endpoint for storing loan data
app.post("/analytics/loans", (req, res) => {
    const { user, amount, interestRate } = req.body;
    console.log(`Loan recorded: User=${user}, Amount=${amount}, InterestRate=${interestRate}`);
    res.status(200).send("Loan data stored.");
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
});
