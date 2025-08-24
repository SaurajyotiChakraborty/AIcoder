import { gemini, createAgent } from "@inngest/agent-kit";
import { inngest } from "./client";

export const helloWorld = inngest.createFunction(
  { id: "hello-world-gemini" },
  { event: "test/hello.world" },
  async ({ event }) => {
    
    const codeAgent = createAgent({
      name: "code-agent",
      system: "You are an expert next.js developer. You write readable , maintain code . You write next.js and react snippets",
      model: gemini({ model: "gemini-2.0-flash-lite" }), // swapped openai -> gemini
    });

    const { output } =await codeAgent.run(
      `write this following snippet:${event.data.value}`,
    );
    

    return {  output };
  },
);
