// Writes web/qr.html, a self-contained page with a QR code to the live app. The result is
// committed, so the deploy doesn't need this step. Run it again if the address changes.
import { writeFileSync } from "node:fs";
import QRCode from "qrcode";

const url = "https://tasker.tlatoani.net/";
const svg = await QRCode.toString(url, {
  type: "svg",
  errorCorrectionLevel: "Q", // Survives a scuffed or dirty printout.
  margin: 4,
  color: { dark: "#000000", light: "#ffffff" },
});

writeFileSync("web/qr.html", `<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <meta name="theme-color" content="#2E6B3A">
  <meta name="description" content="Scan to open Tasker.">
  <title>Open Tasker</title>
  <link rel="icon" type="image/png" href="favicon.png">
  <style>
    * { box-sizing: border-box; }
    html, body { margin: 0; min-height: 100%; }
    body {
      min-height: 100dvh;
      display: flex;
      align-items: center;
      justify-content: center;
      padding: 16px;
      background: linear-gradient(#2E6B3A, #1D4A28);
      color: #fff;
      font-family: system-ui, -apple-system, "Segoe UI", Roboto, sans-serif;
      text-align: center;
    }
    main { width: 100%; max-width: 440px; }
    h1 { margin: 0 0 16px; font-size: 40px; }
    .code { display: block; background: #fff; border-radius: 16px; padding: 8px; }
    .code svg { display: block; width: 100%; height: auto; }
    .link { display: block; margin-top: 16px; color: #fff; font-size: 20px; font-weight: 700; overflow-wrap: anywhere; }
    @media print {
      body { background: #fff; color: #000; }
      .link { color: #000; }
      .code { padding: 0; }
    }
  </style>
</head>
<body>
  <main>
    <h1>Tasker</h1>
    <a class="code" href="/" aria-label="QR code that opens tasker.tlatoani.net">${svg.trim()}</a>
    <a class="link" href="/">tasker.tlatoani.net</a>
  </main>
</body>
</html>
`);
console.log("web/qr.html written for", url);
