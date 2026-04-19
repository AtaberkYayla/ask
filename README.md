# ask

A Bash CLI tool that sends prompts to an LLM via an OpenAI-compatible API.

## Dependencies

- `curl`
- `jq`

## Setup

### 1. Make the script executable
```bash
chmod +x ask
```

### 2. Set environment variables
```bash
export ASK_API_URL="https://api.groq.com/openai/v1/chat/completions"
export ASK_MODEL="llama-3.3-70b-versatile"
export ASK_API_KEY="your_api_key_here"
```

Get a free API key at: https://console.groq.com/keys

## Usage

### Basic prompt
```bash
./ask "What is the capital of France?"
```

### Multiple arguments
```bash
./ask "Establishment dates of" "Turkey" "Azerbaijan" "Japan"
```

### Pipe input
```bash
cat script.sh | ./ask "Explain what this script does:"
```

### Pipe and argument combined
```bash
echo "Rhythim" | ./ask "Fix the spelling:"
```

## Known Limitations

- No conversation history: each call is stateless
- No streaming: response appears all at once
- Requires curl and jq to be installed
- Environment variables must be set each session or added to .bashrc
- Environment variables must be set each session or added to .bashrc
