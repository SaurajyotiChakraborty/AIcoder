import {Sandbox} from "@e2b/code-interpreter";
import { gemini, createAgent } from "@inngest/agent-kit";
import { inngest } from "./client";
import { getsandbox } from "./utils";

export const helloWorld = inngest.createFunction(
  { id: "hello-world-gemini" },
  { event: "test/hello.world" },
  async ({ event,step }) => {
    const SandboxId = await step.run("get-sandbox-id", async()=>{
      const sandbox = await Sandbox.create("vibe-nextjs-takhur-2");
      return sandbox.sandboxId;
    });
    
    const codeAgent = createAgent({
      name: "code-agent",
      system: "You are an expert next.js developer. You write readable , maintain code . You write next.js and react snippets",
      model: gemini({ model: "gemini-2.0-flash-lite" }), // swapped openai -> gemini
    });

    const { output } =await codeAgent.run(
      `write this following snippet:${event.data.value}`,
    );

    const sandboxUrl= await step.run("get-sendbox-url", async ()=>{
      const sandbox= await getsandbox(SandboxId);
      const host=  sandbox.getHost(3000);
      return `https://${host}`
    })
    

    return {  output,sandboxUrl };
  },
);
