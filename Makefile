SHELL := /bin/bash
ASK   := ./ask

# ─── FINAL TARGET ────────────────────────────────────────────────────────────
all: action.plan.md

# ─── PHASE 1: FAN-OUT (parallel) ─────────────────────────────────────────────
quality.md: codebase.txt
	cat $< | $(ASK) "Analyse the following code for code quality: readability, structure, and duplication. Output exactly 5-7 bullet points in the format: problem → fix. Output markdown only." > $@

perf.md: codebase.txt
	cat $< | $(ASK) "Analyse the following code for performance issues: bottlenecks and inefficiencies. Output exactly 5-7 bullet points in the format: issue → optimization. Output markdown only." > $@

security.md: codebase.txt
	cat $< | $(ASK) "Analyse the following code for security vulnerabilities and unsafe patterns. Output exactly 5-7 bullet points in the format: risk → mitigation. Output markdown only." > $@

# ─── PHASE 2: LOCAL SUMMARIZATION ────────────────────────────────────────────
quality.sum.md: quality.md
	cat $< | $(ASK) "Compress the following code quality analysis to exactly 5 bullets. Keep only actionable items. Output markdown bullet points only." > $@

perf.sum.md: perf.md
	cat $< | $(ASK) "Compress the following performance analysis to exactly 5 bullets. Keep only actionable items. Output markdown bullet points only." > $@

security.sum.md: security.md
	cat $< | $(ASK) "Compress the following security analysis to exactly 5 bullets. Keep only actionable items. Output markdown bullet points only." > $@

# ─── PHASE 3: CONCAT REPORT (no LLM) ────────────────────────────────────────
concatenated.md: quality.sum.md perf.sum.md security.sum.md
	{ \
	  echo "## Code Quality"; \
	  cat quality.sum.md; \
	  echo ""; \
	  echo "## Performance"; \
	  cat perf.sum.md; \
	  echo ""; \
	  echo "## Security"; \
	  cat security.sum.md; \
	} > $@

# ─── PHASE 4: FAN-IN #1 (LLM Refine) ────────────────────────────────────────
refined.md: concatenated.md
	cat $< | $(ASK) "You are given a combined code review report with three sections: Code Quality, Performance, and Security. Remove duplicates, keep only high-signal issues, and output a refined version with the same three sections. Each section should have prioritized, concise bullet points only." > $@

# ─── PHASE 5: FAN-IN #2 (Action Plan) ───────────────────────────────────────
action.plan.md: concatenated.md refined.md
	{ cat concatenated.md; echo "---"; cat refined.md; } | \
	$(ASK) "Based on the following code review report, generate a final Engineering Action Plan in markdown. Title: Engineering Action Plan. Include: prioritized actions labeled High/Medium/Low, effort estimate (Small/Medium/Large) for each action, and suggested execution order. Format as a clean markdown document." > $@

.PHONY: all clean

clean:
	rm -f quality.md quality.sum.md perf.md perf.sum.md security.md security.sum.md \
	      concatenated.md refined.md action.plan.md
