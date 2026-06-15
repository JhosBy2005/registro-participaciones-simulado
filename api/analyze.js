const riskRules = [
  { pattern: /pag[ao]|deposito|reserva|transferencia|yape|plin|cuenta bancaria|s\/\d+/i, points: 28, signal: "Solicita pago previo o transferencia" },
  { pattern: /whatsapp|telegram|inbox|dm|mensaje privado/i, points: 16, signal: "Usa canales informales de contacto" },
  { pattern: /urgente|hoy mismo|cupos limitados|ultimo dia|respuesta inmediata/i, points: 14, signal: "Presiona con urgencia artificial" },
  { pattern: /gana|ingresos|sueldo|salario|diario|semanal/i, points: 10, signal: "Promete ingresos llamativos" },
  { pattern: /dni|documento|foto|selfie|datos personales|tarjeta/i, points: 18, signal: "Pide datos personales sensibles" },
  { pattern: /bit\.ly|tinyurl|linktr\.ee|acortador|http:\/\//i, points: 12, signal: "Incluye enlaces sospechosos o poco claros" },
];

function setCorsHeaders(res) {
  res.setHeader("Access-Control-Allow-Origin", "*");
  res.setHeader("Access-Control-Allow-Methods", "GET, POST, OPTIONS");
  res.setHeader("Access-Control-Allow-Headers", "Content-Type");
}

function getPayload(req) {
  if (!req.body) return {};
  if (typeof req.body === "string") {
    try {
      return JSON.parse(req.body);
    } catch {
      return { text: req.body };
    }
  }
  return req.body;
}

function analyzeText(text) {
  const content = String(text || "").trim();
  const foundSignals = [];
  let score = 0;

  for (const rule of riskRules) {
    if (rule.pattern.test(content)) {
      score += rule.points;
      foundSignals.push(rule.signal);
    }
  }

  if (content.length > 0 && content.length < 40) {
    score += 10;
    foundSignals.push("Descripcion demasiado breve");
  }

  const risk = Math.min(score, 100);
  const level = risk >= 65 ? "alto" : risk >= 35 ? "medio" : "bajo";

  return {
    risk,
    level,
    signals: [...new Set(foundSignals)],
    recommendation:
      level === "alto"
        ? "No compartas datos ni realices pagos. Verifica la empresa por canales oficiales."
        : level === "medio"
          ? "Revisa la empresa, el dominio y el canal de contacto antes de responder."
          : "No se detectan senales fuertes, pero valida la oferta antes de postular.",
  };
}

module.exports = function handler(req, res) {
  setCorsHeaders(res);

  if (req.method === "OPTIONS") {
    return res.status(204).end();
  }

  if (req.method === "GET") {
    return res.status(200).json({
      ok: true,
      usage: {
        method: "POST",
        body: { text: "Trabajo remoto, gana S/500 diarios. Escribenos por WhatsApp y paga S/50." },
      },
    });
  }

  if (req.method !== "POST") {
    return res.status(405).json({ error: "Method not allowed" });
  }

  const payload = getPayload(req);
  const text = payload.text || payload.offer || payload.message;

  if (!text || String(text).trim().length < 10) {
    return res.status(400).json({
      error: "Envia un texto de oferta laboral con al menos 10 caracteres.",
    });
  }

  return res.status(200).json({
    ok: true,
    inputLength: String(text).trim().length,
    result: analyzeText(text),
  });
};
