const WHATSAPP_API_URL = "https://graph.facebook.com/v20.0";

interface Lead {
  id: string;
  name: string;
  email: string;
  phone: string;
  company_name?: string;
  instagram?: string;
  monthly_revenue: string;
  business_moment?: string[];
  business_description?: string;
  current_problems?: string[];
  consequence_12_months?: string;
  previous_attempt?: string;
  failed_attempt_details?: string;
  current_systems?: string;
  ideal_system_solution?: string;
  willing_to_invest?: string;
  why_metrifica?: string;
  created_at: string;
}

interface WebhookPayload {
  type: "INSERT" | "UPDATE" | "DELETE";
  table: string;
  record: Lead;
  schema: string;
}

Deno.serve(async (req: Request) => {
  if (req.method !== "POST") {
    return new Response("Method not allowed", { status: 405 });
  }

  const phoneNumberId = Deno.env.get("WHATSAPP_PHONE_NUMBER_ID");
  const accessToken = Deno.env.get("WHATSAPP_TOKEN") ?? Deno.env.get("WHATSAPP_ACCESS_TOKEN");
  const recipientPhone = Deno.env.get("WHATSAPP_RECIPIENT_PHONE");
  const templateName = Deno.env.get("WHATSAPP_LEAD_TEMPLATE_NAME") ?? "novo_lead_metrifica";

  if (!phoneNumberId || !accessToken || !recipientPhone) {
    console.error("Missing WhatsApp env vars");
    return new Response("Server misconfigured", { status: 500 });
  }

  const payload: WebhookPayload = await req.json();

  if (payload.type !== "INSERT" || payload.table !== "leads") {
    return new Response("Ignored", { status: 200 });
  }

  const lead = payload.record;

  const createdAt = new Date(lead.created_at).toLocaleString("pt-BR", {
    timeZone: "America/Sao_Paulo",
  });
  const text = (value?: string) => value?.trim() || "Não informado";
  const list = (value?: string[]) => value?.length ? value.join("; ") : "Não informado";

  const response = await fetch(
    `${WHATSAPP_API_URL}/${phoneNumberId}/messages`,
    {
      method: "POST",
      headers: {
        "Authorization": `Bearer ${accessToken}`,
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        messaging_product: "whatsapp",
        to: recipientPhone,
        type: "template",
        template: {
          name: templateName,
          language: { code: "pt_BR" },
          components: [
            {
              type: "body",
              parameters: [
                { type: "text", text: lead.name },
                { type: "text", text: lead.phone },
                { type: "text", text: lead.email },
                { type: "text", text: text(lead.company_name) },
                { type: "text", text: text(lead.instagram) },
                { type: "text", text: lead.monthly_revenue },
                { type: "text", text: list(lead.business_moment) },
                { type: "text", text: text(lead.business_description) },
                { type: "text", text: list(lead.current_problems) },
                { type: "text", text: text(lead.consequence_12_months) },
                { type: "text", text: text(lead.previous_attempt) },
                { type: "text", text: text(lead.failed_attempt_details) },
                { type: "text", text: text(lead.current_systems) },
                { type: "text", text: text(lead.ideal_system_solution) },
                { type: "text", text: text(lead.willing_to_invest) },
                { type: "text", text: text(lead.why_metrifica) },
                { type: "text", text: createdAt },
              ],
            },
          ],
        },
      }),
    },
  );

  if (!response.ok) {
    const error = await response.text();
    console.error("WhatsApp API error:", error);
    return new Response("WhatsApp error", { status: 500 });
  }

  return new Response("OK", { status: 200 });
});
