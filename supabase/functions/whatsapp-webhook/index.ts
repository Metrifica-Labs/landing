const VERIFY_TOKEN = Deno.env.get("WHATSAPP_VERIFY_TOKEN");

Deno.serve(async (req: Request) => {
  const url = new URL(req.url);

  if (req.method === "GET") {
    const mode = url.searchParams.get("hub.mode");
    const token = url.searchParams.get("hub.verify_token");
    const challenge = url.searchParams.get("hub.challenge");

    if (mode === "subscribe" && token === VERIFY_TOKEN && challenge) {
      return new Response(challenge, { status: 200 });
    }

    return new Response("Forbidden", { status: 403 });
  }

  if (req.method === "POST") {
    const payload = await req.json();
    console.log("WhatsApp webhook payload:", JSON.stringify(payload));
    return new Response("OK", { status: 200 });
  }

  return new Response("Method not allowed", { status: 405 });
});
