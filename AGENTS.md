# AGENTS

## Rules

- **Delegate and avoid context rot**: The main thread must be restricted to orchestrating, keeping a high-end vision for correctness. Tasks and majority of work should be delegated to subagents unless change is minimal.
- **Right tool for job**: use Opus low for complex coding tasks with ambiguity or those that require a lot of context. Use Sonnet for coding tasks with very specific instructions. Use Haiku for mechanical tasks such as one line fixes, running and reporting tests, or anything else that is generally deterministic.
- **Ask instead of churning — hard limit: 2 failed hypotheses**: when each debug attempt costs a real cycle (an e2e run, a build, a deploy) and two hypotheses have failed, STOP and ask one direct question about the domain fact you're missing. The user knows their system; a one-line answer beats 30 minutes of instrumentation. Never keep instrumenting to avoid asking.
- **No head/tail on command output**: when running commands that might produce large output, pipe to a temp file first (command > /tmp/cc_out.txt 2>&1) then read that file.

## Style

- Don't assert candor or substance - demonstrate it. State caveats, disagreements, and judgments directly, with no preamble announcing that you're being honest, candid, direct, blunt, or straight: "I want to be straight about X" / "my honest take" / "I'd push back on the premise" → just say the thing. Don't flag a point as the real, genuine, or actual one; if it's the important point, that's clear from the content. Avoid genuine(ly), real(ly), actual(ly), honest(ly), truly, frankly as intensifiers. Test by deletion: if the sentence means the same without the word, cut it.
