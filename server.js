const express = require("express");
const os = require("os");

const app = express();
const port = process.env.PORT || 3000;

// Wersja aplikacji: odczytana z ENV (które będzie ustawione z ARG w Dockerfile)
const version = process.env.VERSION || "v0.0.0";

app.get("/", (req, res) => {
  const ip = req.ip;
  const hostname = os.hostname();

  res.send(`
    <html>
      <head>
        <meta charset="utf-8" />
        <title>Prosta aplikacja</title>
      </head>
      <body>
        <h1>Prosta aplikacja</h1>
        <p>Adres IP serwera: ${ip}</p>
        <p>Hostname: ${hostname}</p>
        <p>Wersja aplikacji: ${version}</p>
      </body>
    </html>
  `);
});

// Start serwera
app.listen(port, () => {
  console.log(`Express server is running on port ${port}`);
});
